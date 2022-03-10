# Git Release Workflow

English | [中文说明](./i18n/README.zh-cn.md)

Tools for generating Git ChangeLogs, including generating and pushing Release workflows in GitLab CI/CD and GitHub Action's Push Release workflows

- [Git Release Workflow](#git-release-workflow)
  - [How to use for your](#how-to-use-for-your)
    - [Gitlab CI/CD Push Release](#gitlab-cicd-push-release)
    - [GitHub Action Push Release](#github-action-push-release)

## How to use for your
### Gitlab CI/CD Push Release
```yml
release:
  rules:
    - if: '$CI_COMMIT_TAG != null && $CI_PIPELINE_SOURCE == "push"'
      when: on_success
  stage: release-note
  image: shencangsheng/gitlab-release:latest
  script:
    # Pay attention to distinguish the GitLab version
    # <= 13.x use post-gitlab-release-13x
    # >= 14.x use post-gitlab-release-14x
    - post-gitlab-release-14x
```

### GitHub Action Push Release
```yml
on:
  push:
    tags:
      - v*
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