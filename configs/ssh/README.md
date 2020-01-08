# ssh config file
## The SSH Config File Structure and Interpretation Algorithm

Each user on your local system can maintain a client-side SSH configuration file. These can contain any options that you would use on the command line to specify connection parameters, allowing you to store your common connection items and process them automatically on connection. It is always possible to override the values defined in the configuration file at the time of the connection through normal flags to the `ssh` command.

## The Location of the SSH Client Config File

The client-side configuration file is called `config` and it is located in your user’s home directory within the `.ssh` configuration directory. Often, this file is not created by default, so you may need to create it yourself:

`touch ~/.ssh/config`

## Documentation :
Site : [DigitalOcean](https://www.digitalocean.com/community/tutorials/how-to-configure-custom-connection-options-for-your-ssh-client)

Site : SSH.com [ssh.com](https://www.ssh.com/ssh/config)