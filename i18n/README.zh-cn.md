# Git Release Workflow

[English](https://github.com/shencangsheng/Git-Release-Workflow) | 简体中文

生成 Git ChangeLog 的工具，包含在 GitLab CI/CD 中生成并推送 Release 工作流以及 GitHub Action 的推送 Release 工作流

[DockerHub Repositorie](https://hub.docker.com/r/shencangsheng/gitlab-pipeline-release)

- [Git Release Workflow](#git-release-workflow)
  - [尝试使用](#尝试使用)
    - [GitLab CI/CD 推送 Release](#gitlab-cicd-推送-release)
    - [GitHub Action 推送 Release](#github-action-推送-release)
  - [Credits](#credits)
  - [License](#license)

## 尝试使用

### GitLab CI/CD 推送 Release

GitLab Release 需要的 login-action 选项包括：

- PRIVATE-TOKEN：这是您的 GitLab 仓库的访问令牌。 我们需要将 GitLab 访问令牌存储在项目的 CI/CD 变量，命名为`ACCESS_TOKEN`，使它们不会公开在工作流程文件中， 更多信息请参阅[创建和使用 GitLab 访问令牌](https://docs.gitlab.cn/jh/user/profile/personal_access_tokens.html)。

```yml
release:
  rules:
    - if: '$CI_COMMIT_TAG != null && $CI_PIPELINE_SOURCE == "push"'
      when: on_success
  stage: release-note
  image: shencangsheng/gitlab-pipeline-release:latest
  script:
    # 注意区分GitLab版本
    # <= 13.x 使用 post-gitlab-release-13x
    # >= 14.x 使用 post-gitlab-release-14x
    - post-gitlab-release-14x
```

### GitHub Action 推送 Release

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
