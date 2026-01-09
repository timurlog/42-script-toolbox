<!-- Improved compatibility of back to top link: See: https://github.com/othneildrew/Best-README-Template/pull/73 -->
<a name="readme-top"></a>
<!--
*** Thanks for checking out the Best-README-Template. If you have a suggestion
*** that would make this better, please fork the repo and create a pull request
*** or simply open an issue with the tag "enhancement".
*** Don't forget to give the project a star!
*** Thanks again! Now go create something AMAZING! :D
-->


<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]
[![42 Profile][42]][42-url]


<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/timurlog/42-script-toolbox">
    <img src="assets/sh_logo.png" alt="Logo" width="120" height="120">
  </a>

<h3 align="center">42 Script Toolbox</h3>

  <p align="center">
	A collection of shell scripts to automate project setup and configuration tasks for 42 Campus students.
	<br />
	<a href="https://github.com/timurlog/42-script-toolbox"><strong>Explore the docs »</strong></a>
	<br />
	<br />
    <a href="https://github.com/timurlog/42-script-toolbox/issues/new?labels=bug&template=bug-report---.md">Report Bug</a>
    &middot;
    <a href="https://github.com/timurlog/42-script-toolbox/issues/new?labels=enhancement&template=feature-request---.md">Request Feature</a>
  </p>
</div>

<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#linuxmacos-installation">Installation</a></li>
        <li><a href="#update">Update</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <!-- <li><a href="#roadmap">Roadmap</a></li> -->
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>


<!-- ABOUT THE PROJECT -->
## About The Project

[![Product Name Screen Shot][product-screenshot]]()

This project is a collection of utility scripts designed to streamline the workflow at 42 Campus.

It provides tools to easily initialize projects in C, C++, and other languages commonly used at 42.

The scripts also simplify updating essential components like your libft library, Makefiles, and project configurations.

The goal is to save time on repetitive setup tasks so you can focus on coding.

<p align="right">(<a href="#readme-top">back to top</a>)</p>


### Built With

- [![Shell][Shell]][Shell-url]

<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- GETTING STARTED -->
## Getting Started

Here are the steps to follow to install 42 Script Toolbox on your 42 Linux machine.

### Linux Installation

Execute this Command

   ```sh
   bash -c "$(curl -fsSL https://raw.github.com/timurlog/42-script-toolbox/main/bin/install.sh)"
   ```

During installation, the script will prompt you for:

- Your 42 intra username
- Your 42 email address
- The link to your libft repository (GitHub, GitLab, etc.)

Your libft repository must be structured as follows:

```
.
├── include
│   └── libft.h
└── libft
    ├── Makefile
    └── *.c
    └── ...
```

> **Example:** You can use [my libft repository](https://github.com/timurlog/Libft) as a reference.

### Update

Execute this Command

   ```sh
   bash -c "$(curl -fsSL https://raw.github.com/timurlog/42-script-toolbox/main/bin/update.sh)"
   ```

<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- USAGE EXAMPLES -->
## Usage

### The basic syntax is:

   ```sh
   cmd
   ```

### Cmd Available in my 42 Script Toolbox Command

| Cmd        | Description                                                               |
|------------|---------------------------------------------------------------------------|
| `snew`     | Create a new project from templates and initialize basic files.           |
| `slib`     | Add your libft library to the current project.                            |
| `smake`    | Generate the project's Makefile and compilation settings.                 |
| `signore`  | Add a standard .gitignore to the current project.                         |
| `spush`    | Update your libft repo with the libft version located in the current dir. |
| `supdate`  | Update the toolbox.                                                       |
| `shelp`    | Show help information.                                                    |
| `sversion` | Show toolbox version.                                                     |


<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Top contributors:

<a href="https://github.com/timurlog/42-script-toolbox/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=timurlog/42-script-toolbox" alt="contrib.rocks image" />
</a>

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE.txt` for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- CONTACT -->
## Contact

Timur Logie - [42 Profile](https://profile.intra.42.fr/users/tilogie) - tilogie@student.42belgium.be - timur.logie@gmail.com

Project Link: [https://github.com/timurlog/42-script-toolbox](https://github.com/timurlog/42-script-toolbox)

<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- ACKNOWLEDGMENTS -->
## Acknowledgments

* [Choose a License](https://choosealicense.com/)
* [README.md Template](https://github.com/othneildrew/Best-README-Template)
* [Francinette install.sh Inspiration](https://github.com/xicodomingues/francinette/blob/master/bin/install.sh)

<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/timurlog/42-script-toolbox.svg?style=for-the-badge
[contributors-url]: https://github.com/timurlog/42-script-toolbox/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/timurlog/42-script-toolbox.svg?style=for-the-badge
[forks-url]: https://github.com/timurlog/42-script-toolbox/network/members
[stars-shield]: https://img.shields.io/github/stars/timurlog/42-script-toolbox.svg?style=for-the-badge
[stars-url]: https://github.com/timurlog/42-script-toolbox/stargazers
[issues-shield]: https://img.shields.io/github/issues/timurlog/42-script-toolbox.svg?style=for-the-badge
[issues-url]: https://github.com/timurlog/42-script-toolbox/issues
[license-shield]: https://img.shields.io/badge/License-MIT-green?style=for-the-badge
[license-url]: https://github.com/timurlog/42-script-toolbox/blob/main/LICENSE.txt
[42]: https://img.shields.io/badge/-Profile-black.svg?style=for-the-badge&logo=42&colorB=555
[42-url]: https://profile.intra.42.fr/users/tilogie
[product-screenshot]: assets/image.png
[C]: https://img.shields.io/badge/C-blue?style=for-the-badge&logo=c&logoColor=white
[C-url]: https://www.c-language.org/ 
[Makefile]: https://img.shields.io/badge/Makefile-0779c1?style=for-the-badge&logo=gnubash&logoColor=white
[Makefile-url]: https://makefile.site/
[Shell]: https://img.shields.io/badge/Shell-Bash-4EAA25?style=for-the-badge&logo=gnubash&logoColor=white
[Shell-url]: https://bash-shell.net/
