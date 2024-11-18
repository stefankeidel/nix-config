# Python dev setup using poetry

A reusable flake for my Python dev setup. All projects at work and
personal are managed by poetry, so this should work as a resuable rig
from anywhere that's a poetry project.

``` shell
cd <poetryProject>
nix develop ~/code/nix-config/utils/python-dev#python311 -c $SHELL
```

