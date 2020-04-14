# Symfony Bootstrap

An easy way to bootstrap symfony projects on any environments.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

Before going any further, you **must** have the following stack on your environment:

- docker
- docker-compose 

Additionally, this project also provides shortcuts for many tools. To use them all, you may want:

- make
- git

### Installing

Clone this repository:

```
$ git clone https://github.com/adaniloff/symfony-bootstrap.git my-new-project
```

Go inside your project's folder:

```
cd my-new-project
```

Prepare the docker stack:

```
$ docker-compose build && make up
```

At this point, you might decide to setup your environment:

```
$ make install
```

This will install your SF5 stack.
You can now access to the SF commands through the Makefile, with `make console`.

Simply run `make` to get help on your Makefile commands at any time. 

### Advanced git automation

Some hooks are bundled with this project. We decided to enforce our own git messages policy. To have benefits of our configuration, you can do the following:

#### Hooks

First, copy the hooks into you git hooks folder:

```
$ cp .git.dist/hooks/* .git/hooks/
```

They will enforce our messages policies based on regexp rules, thus avoiding you to commit or push poorly made git messages. You can see more about those rules by looking at the `.git.dist/.gitmessage` file.

#### Git message template

First, copy the template to your home folder:

```
$ cp .git.dist/.gitmessage ~/
```

Then use the template message by adding the following in your `.git/config`:

```
[commit]
        template = ~/.gitmessage
```

## Authors

* **Aleksandr Daniloff** - *Initial work* 

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details

## Acknowledgments
- [RomaricP](https://github.com/romaricp) for this [wonderful article](https://medium.com/@romaricp/the-perfect-kit-starter-for-a-symfony-4-project-with-docker-and-php-7-2-fda447b6bca1). 
- [PurpleBooth](https://github.com/PurpleBooth) for this [README.md template](https://gist.github.com/PurpleBooth/109311bb0361f32d87a2)
