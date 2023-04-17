# HR-TIL

![til](https://raw.githubusercontent.com/dillonhafer/hr-til/master/app/assets/images/banner.png)

> TIL is an open-source project by the team at
> [Hashrocket](https://hashrocket.com/) that catalogues the sharing &
> accumulation of knowledge as it happens day-to-day. Posts have a 200-word
> limit, and posting is open to any Rocketeer as well as select friends of the
> team. We hope you enjoy learning along with us.

This site was open-sourced as a window into our development process, as well as
to allow people to experiment with the site on their own and contribute to the
project.

Today I Learned was ported to Elixir/Phoenix in 2017 ([source
code](https://github.com/hashrocket/tilex)), and the Rails application is no
longer in production or actively maintained by Hashrocket. Thanks to all of our
[contributors](https://github.com/hashrocket/hr-til/graphs/contributors)!

This Rails application is now in production and actively maintained by Dillon Hafer

### Install

If you are creating your own version of the site,
[fork](https://help.github.com/articles/fork-a-repo/) the repository.

Then, follow these setup steps:

```sh
$ git clone https://github.com/dillonhafer/hr-til
$ cd hr-til
$ bundle
$ cp .env{.example,}
$ rails db:setup
$ bin/dev
```

In development, `db:seed` will load sample data for channels, developers, and
posts. Omit this command to opt-out of this step, or create your own sample
data in `db/seeds/development.rb`.

Authentication is managed by Omniauth and Google. See the
[omniauth-google-oauth2
README](https://github.com/zquestz/omniauth-google-oauth2/blob/master/README.md)
and [Google Oauth 2
docs](https://developers.google.com/identity/protocols/OAuth2WebServer) for
setup instructions. To allow users from a domain, multiple domains, or a
specific email to log in, set those configurations in your environmental
variables:

```yml
# config/application.yml

permitted_domains: "hashrocket.com|hshrckt.com"
permitted_emails: "friend@whitelist.com"
```

Ensure you have set the google client id and google client secret via Oauth instructions.

### Testing

Run all tests with:

```
$ rake
```

### Dependencies

- The gem `selenium-webdriver` depends on the Firefox and/or Chrome browsers.

### Environmental Variables

`basic_auth_credentials` both toggles and defines basic authentication:

```yml
# .env

basic_auth_credentials: username:password
```

`slack_post_endpoint` allows the app to post to [Slack](https://slack.com/):

```yml
# .env

slack_post_endpoint: /services/some/hashes
```

### Contributing

1. [Fork](https://help.github.com/articles/fork-a-repo/) it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

Bug reports and pull requests are welcome on GitHub at
https://github.com/hashrocket/hr-til. This project is intended to be a safe,
welcoming space for collaboration, and contributors are expected to adhere to
the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

### Usage

We love seeing forks of Today I Learned in production! Please consult our
[usage guide](/USAGE.md) for guidelines on appropriate styling and attribution.

### License

TIL is released under the [MIT License](http://www.opensource.org/licenses/MIT).

### Deploy on a DigitalOcean droplet

```
cp .env.example .env.production
ansible-playbook -i til.dillonhafer.com, config/digital-ocean-ansible.yml
mina setup
mina deploy
```

---

### About

[![Hashrocket logo](https://hashrocket.com/hashrocket_logo.svg)](https://hashrocket.com)

TIL is supported by the team at [Hashrocket, a
multidisciplinary design and development consultancy](https://hashrocket.com). If you'd like to [work with
us](https://hashrocket.com/contact-us/hire-us) or [join our
team](https://hashrocket.com/contact-us/jobs), don't hesitate to get in touch.
