# `sboosali.github.io`


## Installation

### `nix`

`nix` provisions an environment with programs for web development:

• HTML/CSS/JS (and Bash): Linters.
• JS: Package Manager, Build Tool.
• JS: Interpreter, Minifier.

See `./nix/programs.nix`.

### 



```sh
$ nix-shell
```

## Usage

remote:

    open http://sboosali.github.io

local:

    open ~/sboosali.github.io/index.html


## Implementation

Flexbox Tutorial: <https://css-tricks.com/snippets/css/a-guide-to-flexbox/>


## Data

```sh
$ curl "https://img.scryfall.com/cards/png/en/tsp/27.png?1517813031" > images/MagusOfTheDisk.png 
```

```sh
$ identify images/MagusOfTheDisk.png 

images/MagusOfTheDisk.png PNG 745x1040 745x1040+0+0 8-bit sRGB 1.63024MiB 0.000u 0:00.000
```


## Domain Name

`sboo.io`

### Registration / Purchase via namecheap.com

<https://www.namecheap.com/domains/registration/results.aspx?domain=sboo.io>

Domain Registration: $32.88 / yr

PositiveSSL: $8.88 / yr

> Secure your new domain with an SSL certificate.

WhoisGuard Privacy: $0

Redirections:

- <sboo.io> → <http://www.sboo.io/>

#### namecheap & SSL

must activate "Comodo SSL Certificate".

CSR abbreviates Certificate Signing Request

1. Generate CSR-Code

> a CSR-Code is generated upon your request by your hosting company for the website you want to secure with an SSL certificate.






## Hosting







## Server

<https://medium.com/@jasonrigden/how-to-host-a-static-website-with-nginx-8b2dd0c5b301>

### `ngnix`

#Install:

    sudo apt-get install nginx

#Launch:

    sudo systemctl start nginx

#Reload:

    sudo systemctl reload nginx

### Firewall

#Install:

    sudo apt-get install ufw

#Launch:

    sudo ufw allow 'Nginx Full'
    
    # allows HTTP and HTTPs traffic.

#Reload (the firewall rules):

    sudo ufw reload

> Your server should be running a firewall. I recommend the Uncomplicated Firewall (UFW). If you need help with UFW, check out, A Guide to the Uncomplicated Firewall (UFW) for Linux. 

### 





## 

