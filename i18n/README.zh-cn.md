# Git Release Workflow

[English](https://github.com/shencangsheng/Git-Release-Workflow) | 中文说明

生成Git ChangeLog的工具，包含在GitLab CI/CD中生成并推送Release工作流以及GitHub Action的推送Release工作流

## 尝试使用
### Gitlab CI/CD 推送Release
```yml
release:
  rules:
    - if: '$CI_COMMIT_TAG != null && $CI_PIPELINE_SOURCE == "push"'
      when: on_success
  stage: release-note
  image: shencangsheng/gitlab-release:latest
  script:
    # 注意区分GitLab版本
    # <= 13.x 使用 post-gitlab-release-13x
    # >= 14.x 使用 post-gitlab-release-14x
    - post-gitlab-release-14x
```

