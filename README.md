# Hamckle Frester

Import your Project Hamster time logs into LetsFreckle.com, using a confortable command-line UI.


## Installation

    $ gem install hamckle_frester


## Usage

First you need to configure Hamckle with:

    $ hamckle init

Doing this will ask you for your Freckle API access (host, username and token).
Hamckle keeps its configuration in a yaml file under ~/.hamckle/settings.yml (you can change this).

Push time logs to freckle:

    $ hamckle push --from yyyy-mm-dd

This command tells Hamckle to search for all Hamster entries from specified date, asks your permit to push, and then marks the pushed entries with a tag 'freckle' in Hamster.
Every Hamster category corresponds to a Freckle project. Associations between Hamster categories and Freckle projects are made interactively, and stored in the configuration file.


## Contributing

1. Fork it ( http://github.com/<my-github-username>/hamckle_frester/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
