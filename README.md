# Duo-BLT

This project contains the source files and tooling instructions for the Duo-BLT site.  The project structure and local environment setup is based on [Acquia BLT and Docksal](https://blog.docksal.io/docksal-and-acquia-blt-1552540a3b9f).  The site is hosted on Pantheon, and BLT is used to create and push build artifacts to Pantheon during deployments.

## Getting Started

Before you begin you need to have access to the [Pantheon application](https://dashboard.pantheon.io/sites/2c9fcde8-7aca-4ca5-ba16-b547e1f5ded0) for this project.  You also need to have git and composer installed on your local machine.

1. [Install Docksal](https://docksal.io/installation/#macos-docker-for-mac) using Docker for Mac instead of VirtualBox.

    **Ensure Docker is configured to allow 64 GB containers via Preferences > Disk**.

1. [Install Terminus](https://pantheon.io/docs/terminus/install/).  Confirm successful install using this command:

    `terminus site:info duo-blt`

1. Clone this repository.

    `$ git clone git@github.com:DuoConsulting/duo-blt.git`

1. Configure hosting for running `fin pull`. Add a docksal-local.env file within the .docksal directory and add your credentials:

    Pantheon:
    `SECRET_TERMINUS_TOKEN='TOKEN_GOES_HERE'`

     or

    Acquia:
    ```
    SECRET_ACAPI_EMAIL='user@duoconsulting.com'
    SECRET_ACAPI_KEY='KEY_GOES_HERE'
    ```

    Please see the [fin pull documentation](https://docs.docksal.io/fin/fin-pull/) for more information about the Docksal command and [Pantheon's Machine Token Documentation](https://pantheon.io/docs/machine-tokens) or [Acquia's API v1 Authentication Documentation](https://docs.acquia.com/acquia-cloud/develop/api/auth/v1/) to obtain tokens.

1. Initialize your local environment.  This starts up Docksal, initializes your local Drupal instance and downloads the remote database and files from Pantheon to your local.

    `$ cd duo-blt`

    `$ fin init`
    
    `$ fin pull db`

1. Browse to the site:

    [http://duo-blt.docksal](http://duo-blt.docksal)

1. Login to the site:

    `$ fin drush uli`

    The [fin utility](https://docs.docksal.io/fin/fin-help/) is used to execute all commands in your local environment.  You can also ssh into your Docksal container using `fin bash`.  Note that git should be run in your native OS **without fin**.

1. To ensure that your local development environment has all caching disabled (so that changes to template files show up without a cache-rebuild, for example), uncomment the following two lines in /docroot/sites/default/settings/local.settings.php:

    `$settings['cache']['bins']['render'] = 'cache.backend.null';` (line 77)
    
    `$settings['cache']['bins']['dynamic_page_cache'] = 'cache.backend.null';` (line 85)

    ...and add the following line to local.settings.php:

    `$settings['cache']['bins']['page'] = 'cache.backend.null';`

## Next Steps

Use your normal development workflow EXCEPT do **NOT** commit CSS files to the repo.  Push feature branches to the GitHub repo and [create pull requests](https://help.github.com/articles/creating-a-pull-request/) using master as the base branch and your feature branch as the head branch.  After pull requests are merged, switch back to the master branch and git pull.  Then start another feature branch.  Please note that the repo installs git hooks that validate commits follow [Drupal coding standards](https://www.drupal.org/docs/develop/standards/coding-standards).

1. To download a new module:

    `$ fin composer require drupal/modulename`

    You will then need to commit composer.json and composer.lock.

1. To enable a module and export its settings:

    `$ fin drush en modulename`

    `$ fin drush cex`

    This will export all local settings.  Please ensure you only check in the settings associated with your module.  Typically this is core.extension.yml and  modulename.settings.yml.

1. For front end theme development, run the following **ONCE** to initialize it:

    `$ fin blt frontend:setup`

1. Run the following to compile SASS to CSS after each set of styling changes:

    `$ fin blt frontend:build`

1. Or, if you are using the duo_foundation theme, you can do the following to watch and compile your SASS using the same versions of node/npm used by the build process:

    `$ fin bash` (to shell into the docksal container)

    `$ cd /var/www/docroot/themes/custom/duo_foundation`

    `$ npm run watch`

1. Periodically you should pull from Pantheon to pick up the latest changes there.  Run these commands to pull, keeping in mind **this will blow away any existing test content** you have installed to your local Drupal instance.

    `$ git checkout master`

    `$ git pull origin master`

    `$ fin pull db`

    You can also pull files:

    `$ fin pull files`

## Updating Drupal

1. To update a module:

    `$ fin composer update drupal/modulename`

1. To update Drupal core:

    `$ fin composer update acquia/blt drupal/core webflo/drupal-core-require-dev --with-dependencies`

    You will then need to commit composer.lock and possibly blt/.schema_version if it changed.

    The command above updates more than just Drupal core because it is important to keep Acquia BLT in sync with the core version of Drupal.  Otherwise, you can run into conflicts between components of your technology stack. If drupal/core does not update after running a composer update command, check this page for information about resolving any dependency blocks:

    [General overview of updating core via composer](https://www.drupal.org/docs/8/update/update-core-via-composer)

    As a last resort, a general `composer update` can be run, but this updates all modules and frameworks, not just Drupal core, so it will require more regression testing than a core update by itself.

1. After a module or core upgrade, you may need to run database updates.

    `$ fin drush updb`

1. Remember to export any changes to configuration that result from your updates.

    `$ fin drush cex`

## CircleCI

This project has CircleCI integration included.  Anytime a branch or tag is pushed to GitHub, CircleCI will follow up with a build (for feature branches) or a build-and-deploy (for other branches and tags).

CircleCI is also configured to do a test build any time a feature branch is pushed to GitHub.  If the feature branch is part of a pull request, GitHub will display the results of the test build on the pull request page in GitHub.  See the Resource links at the bottom of this README to access the CircleCI jobs and configuration if direct access is needed.

## Resources

* Pantheon application - [https://dashboard.pantheon.io/sites/2c9fcde8-7aca-4ca5-ba16-b547e1f5ded0](https://dashboard.pantheon.io/sites/2c9fcde8-7aca-4ca5-ba16-b547e1f5ded0)
* BLT - [https://blt.readthedocs.io/en/stable/](https://blt.readthedocs.io/en/stable/)
* CircleCI jobs - [https://circleci.com/gh/DuoConsulting/duo-blt](https://circleci.com/gh/DuoConsulting/duo-blt)
* CircleCI configuration - [https://circleci.com/gh/DuoConsulting/duo-blt/edit](https://circleci.com/gh/DuoConsulting/duo-blt/edit)
* Docksal - [https://docksal.io](https://docksal.io)
* GitHub - [https://github.com/DuoConsulting/duo-blt](https://github.com/DuoConsulting/duo-blt)
* Jira - [https://teamduo.atlassian.net/projects/TT](https://teamduo.atlassian.net/projects/TT)
* Confluence
  * [Duo-BLT](https://teamduo.atlassian.net/wiki/spaces/TT/pages/100335617/duo-blt)
  * [Duo Starter Installation Profile](https://teamduo.atlassian.net/wiki/spaces/TT/pages/96698369/Duo+Starter+Installation+Profile)
  * [Layout Builder](https://teamduo.atlassian.net/wiki/spaces/TT/pages/109478120/Layout+Builder)
