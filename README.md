# Git Release Workflow

English | [中文说明](./i18n/README.zh-cn.md)

Tools for generating Git ChangeLogs, including generating and pushing Release workflows in GitLab CI/CD and GitHub Action's Push Release workflows

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

