# Bioinformatics

This is a project for the Bioinformatics college elective.  It's comprised of a number of exercises
that involve sequence translation (mRNA => protein sequence), BLAST search and Multiple Sequence
Alignment (MSA) among others.

## Installation

0. [Install Ruby](https://www.ruby-lang.org/en/downloads) if your system does not include it. We
recommend using a version manager (eg. rbenv, rvm, rvm) if you plan on installing more than one
Ruby in your system.
1. Clone the repo.
1. Install the `bundler` gem which installs dependencies by running
    ```bash
    gem install bundler
    ```
1. Install dependencies by running the following on the project root:
    ```bash
   bundle install
    ```

## Usage

Each exercise is run separately and has its own arguments. A README is provided
in every exercise for a quick description of its behavior. Usage information for
each exercise can be obtained by running:
```bash
ruby lib/bioinformatics/tpX/exY/main.rb --help
```

**NOTE:** Some exercises have additional non-Ruby dependencies or notes that are
specified in the exercise's README.  Be sure to check them out before running.
