# Git Release Workflow

English | [简体中文](./i18n/README.zh-cn.md)

Tools for generating Git ChangeLogs, including generating and pushing Release workflows in GitLab CI/CD and GitHub Action's Push Release workflows

[DockerHub Repositorie](https://hub.docker.com/r/shencangsheng/gitlab-pipeline-release)

- [Git Release Workflow](#git-release-workflow)
  - [How to use for your](#how-to-use-for-your)
    - [GitLab CI/CD Push Release](#gitlab-cicd-push-release)
    - [GitHub Action Push Release](#github-action-push-release)
  - [Credits](#credits)
  - [License](#license)

## How to use for your

### GitLab CI/CD Push Release

The login-action options required by GitLab Release include:

- PRIVATE-TOKEN：This is the access token for your GitLab repository. We need to store the GitLab access tokens in the project's CI/CD variable, named `ACCESS_TOKEN`, so that they are not exposed in the workflow file, see [Creating and Using GitLab Access Tokens](https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html) for more information

```yml
release:
  rules:
    - if: '$CI_COMMIT_TAG != null && $CI_PIPELINE_SOURCE == "push"'
      when: on_success
  stage: release-note
  image: shencangsheng/gitlab-pipeline-release:latest
  script:
    # Pay attention to distinguish the GitLab version
    # <= 13.x use post-gitlab-release-13x
    # >= 14.x use post-gitlab-release-14x
    - post-gitlab-release-14x

generic:
  rules:
    - if: '$CI_COMMIT_TAG != null && $CI_PIPELINE_SOURCE == "push"'
      when: on_success
  stage: generic
  image: shencangsheng/gitlab-pipeline-release:latest
  script:
    - tar -czf dist.tar.gz dist
    - tar -czf docs.tar.gz docs
    - post-gitlab-release-generic-14x ./dist.tar.gz dist.tar.gz
    - post-gitlab-release-generic-14x ./docs.tar.gz docs.tar.gz
    - post-gitlab-release-links-14x -n dist -u "${CI_API_V4_URL}/projects/${CI_PROJECT_ID}/packages/generic/release/${CI_COMMIT_TAG}/dist.tar.gz" -t package
    - post-gitlab-release-links-14x -n docs -u "${CI_API_V4_URL}/projects/${CI_PROJECT_ID}/packages/generic/release/${CI_COMMIT_TAG}/docs.tar.gz" -t runbook
  dependencies:
    - build
```

### GitHub Action Push Release

```yml
on:
  push:
    tags:
      - "[0-9]+.*"
      - "v*"
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Create Release
        run: |
          curl -fsSL -o changelog-echo.sh `wget -qO- -t1 -T2 "https://api.github.com/repos/shencangsheng/Git-Release-Workflow/releases/latest" | grep "browser_download_url" | grep 'changelog-echo.sh"' | head -n 1 | awk -F ': "' '{print $2}' | sed 's/\"//g;s/,//g;s/ //g'`
          bash changelog-echo.sh >CHANGELOG.md
      - name: Archive code coverage results
        uses: actions/upload-artifact@v3
        with:
          name: artifact
          path: |
            CHANGELOG.md
  release:
    needs: build
    runs-on: ubuntu-latest
    steps:
      - name: Download the artifact
        uses: actions/download-artifact@v1
        with:
          name: artifact
          path: ./
      - name: Create Release
        id: create_release
        uses: actions/create-release@v1
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        with:
          tag_name: ${{ github.ref }}
          release_name: Release ${{ github.ref }}
          draft: false
          prerelease: false
          body_path: CHANGELOG.md
```

## Credits

This project is incubated by the [shencangsheng/GitLab-Release-Workflow](https://github.com/shencangsheng/GitLab-Release-Workflow) available in the GitHub project.

This project was inspired by the [zitsen/release-workflow-demo](https://github.com/zitsen/release-workflow-demo) available in the GitHub project.

## License

A short snippet describing the license (MIT)

MIT © Cangsheng Shen
