## My Firewall
**Create with iptables**

## Firewall script at boot:
**Installation:**

```shell
$ sudo cp script-firewall.sh /etc/init.d/firewall
```
> Copy script-firewall.sh to `/etc/init.d/firewall`

***

```shell
$ sudo ln -s /etc/init.d/firewall /etc/rc2.d/S01firewall
```
> Make symbolic links for start the service of `/etc/init.d/firewall` to `/etc/rc2.d/S01firewall`

***

```shell
$ sudo ln -s /etc/init.d/firewall /etc/rc0.d/K01firewall
```
> Make symbolic links for kill the service of `/etc/init.d/firewall` to `/etc/rc0.d/K01firewall`

***

```shell
$ sudo systemctl start firewall.service
```
> Start the service firewall

***

```shell
$ sudo systemctl enable firewall.service
```
> Enable the service every each boot

## List of TCP; UDP Port numbers
* Wiki: [Listing wiki](https://en.wikipedia.org/wiki/List_of_TCP_and_UDP_port_numbers)
