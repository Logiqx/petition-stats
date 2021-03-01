# Jenkins

Jenkins is used by this project for CI/CD and scheduled batch jobs.

Rather than describe all of the jobs in great detail this document will simply list the dependencies.



## petition-stats-refresh-reports

This job refreshes all of the petition reports and has the following dependencies:

- petition-stats-refresh-reports
  - *Schedule H \* \* \* \**
  - petition-stats-docker-build
    - *GitHub trigger on petition-stats repository*

To set up Jenkins the jobs should be created and run in the following order:

1. petition-stats-docker-build
2. petition-stats-refresh-reports

