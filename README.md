<center> 
<h1>Elixir playground</h1>
This project enables running or compiling Elixir code without having Elixir installed.
</center> 

# Prerequisites
You must have [Docker](https://www.docker.com) and [GNU Make](https://www.gnu.org/software/make/) installed.

# Elixir Interactive shell
`make iex`

# Run Elixir Code
- Drop your script at /scripts
- `make shell` to shell into a container which has Elixir installed
- In the container `elixir [your script]`

# Cleanup
`make clean`