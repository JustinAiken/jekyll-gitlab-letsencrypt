[![Gem Version](http://img.shields.io/gem/v/jekyll-gitlab-letsencrypt.svg)](https://rubygems.org/gems/jekyll-gitlab-letsencrypt) [![Build Status](http://img.shields.io/travis/JustinAiken/jekyll-gitlab-letsencrypt/master.svg)](http://travis-ci.org/JustinAiken/jekyll-gitlab-letsencrypt) [![Coveralls branch](http://img.shields.io/coveralls/JustinAiken/jekyll-gitlab-letsencrypt/master.svg)](https://coveralls.io/r/JustinAiken/jjekyll-gitlab-letsencrypt?branch=master) [![Code Climate](http://img.shields.io/codeclimate/github/JustinAiken/jekyll-gitlab-letsencrypt.svg)](https://codeclimate.com/github/JustinAiken/jekyll-gitlab-letsencrypt)

# jekyll-gitlab-letsencrypt

![img](doc/image.png)

This plugin automagically does the entire the letsencrypt process for your gitlab-hosted jekyll blog!

- *(automatic)* It registers your email to the letsencrypt server
- *(automatic)* It generates a challenge file, and commits it directly via the gitlab API
- *(automatic)* It sleeps until the challenge file is live on the internet
- *(automatic)* It asks letsencrypt to verify it
- *(automatic)* It spits out the certificate chain and private key
- *(automatic)* It updates the gitlab pages domain settings to use the certificate

## Usage

### Prerequisites

You must have:
- A jekyll blog
  - Hosted on gitlab pages
  - With a domain name set up and working
- Gitlab CI setup such that when you push to `master` (or your preferred branch), your changes are deployed live

Versions supported:
- Jekyll 3+
- Ruby 2.1+

### Installation

- Add to your Gemfile:

```ruby
  group :jekyll_plugins do
    gem 'jekyll-emojis'
    gem 'jekyll-more-emojis'
++  gem 'jekyll-gitlab-letsencrypt'
  end
```

and run `bundle install`

## First-time Configuration

- Get a personal access token: https://gitlab.com/profile/personal_access_tokens

Add a `gitlab-letsencrypt` to your `_config.yml`:

```yaml
gitlab-letsencrypt:
  # Gitlab settings:
  personal_access_token: 'MUCH SECRET'             # Gotten from the step above ^^
  gitlab_repo:           'gitlab_user/gitlab_repo' # Namespaced repository identifier

  # Domain settings:
  email:                 'example@example.com'     # Let's Encrypt email address
  domain:                'example.com'             # Domain that the cert will be issued for

  # Jekyll settings:
  base_path:  './'               # Where you want the file to go
  pretty_url: false              # Add a "/" on the end of the URL... set to `true` if you use permalink_style: pretty
  filename:   'letsencrypt.html' # What to call the generated challenge file

  # Delay settings:
  initial_delay: 120 # How long to wait for Gitlab CI to push your changes before it starts checking
  delay_time:     15 # How long to wait between each check once it starts looking for the file

  # Optional settings you probably don't need:
  gitlab_url: 'https://someurl'  # Set if you need to use a self-hosted GitLab instance
  endpoint:  'https://somewhere' # if you're doing the ACME thing outside of letsencrypt
  branch:    'master'            # Defaults to master, but you can use a different branch
  layout:    'null'              # Layout to use for challenge file - defaults to null, but you can change if needed
  scheme:    'https'             # Scheme to use for challenge request; default http
```

### Running

- Just type `jekyll letsencrypt`

```shell
$ jekyll letsencrypt
Registering example@example.com to https://acme-v01.api.letsencrypt.org/...
Pushing file to Gitlab
Commiting challenge file as lets.html
Done Commiting! Check https://gitlab.com/gitlab_user/gitlab_repo/commits/master
Going to check http://example.com/.well-known/acme-challenge/lots_of_numbers/ for the challenge to be present...
Waiting 120 seconds before we start checking for challenge..
Got response code 404, waiting 15 seconds...
Got response code 404, waiting 15 seconds...
Got response code 200, file is present!
Requesting verification...
Challenge status = valid
Challenge is valid!
Certificate retrieved!
Updating domain example.com pages setting with new certificates..
Success!
```

### Alternative token usage

If you don't want to put your secret gitlab token in your `_config.yml`, you can pass it as an ENV var when you run the command:

```bash
GITLAB_TOKEN="VERY_SECRET_NOT_IN_GIT_PLEASE" jekyll letsencrypt
```

# License

MIT

# Credits/thanks

- :heart: Gitlab for free page hosting, free repos, and free CI!
- :heart: the Jekyll team for the easy-to-use blogging engine!
- Inspired by the excellent [gitlab-letsencrypt](https://github.com/rolodato/gitlab-letsencrypt) npm package.
