# ☁️ Cloudy

An [armbian][armbian]-based firmware image for my edge network appliances. So far the following boards are supported:

- [`nanopi-r5s`][nanopi-r5s]

## Usage

Make sure to have a recent version of [Docker][docker], [Git][git] and `build-essential` installed, then run the following commands:

```bash
# Build the image for the NanoPi R5S.
make build
```

## License

Because this software includes GPL licensed software, the whole project is licensed under the GPL v3.0 license. See the [LICENSE][license] file for more information.

[armbian]: https://www.armbian.com/
[nanopi-r5s]: https://www.friendlyelec.com/index.php?route=product/product&product_id=287
[docker]: https://www.docker.com/
[git]: https://git-scm.com/
[license]: LICENSE.md
