# .dots

![Desktop](./media/screen.png)

New and upgraded dotfiles, now with Ansible.

## Danger, Will Robinson!

For obvious reasons, you **should not** run this on your own machine. I **will break your stuff**
and **replace it with my stuff**. However, you can definitely use this repository to bootstrap
your own.

This Ansible project is only guaranteed to be comptible with Debian 10, or whichever the latest
stable Debian version is.

## Goals and non-goals

The goal is to be able to configure my stuff on a fresh machine installs as fast as possible and with as few
manual steps as possible. Having a production grade Ansible project is not a goal of this project, but I will try
my best to keep the manifests somewhat maintainable for the benefit of my own sanity.

## How to use

1. Set up machine with basic install of Debian with no desktop environment.
2. Install Ansible dependencies `sudo apt install python3 python3-pip git`
3. Install Ansible `sudo pip3 install ansible`
4. Clone this repository somewhere.
5. Edit `group_vars/all` as required.
6. As a regular user, execute apply commands as shown bellow.

`ansible-playbook -i hosts site.yml -K -C` will apply in check mode.

`ansible-playbook -i hosts site.yml -K` will apply against localhost.

## Things not yet automated

- Base OS installation is still pretty manual. Backports and non-free is required.
- Gnome shell extensions - `Arc menu`, `Dash to panel`, `Openweather`, `User themes`
- Jetbrains toolbox installation (no deb available)

## But but but my bootstrap scripts and manual copy pasting of everything?!

Haha Ansible manifests go brrr
