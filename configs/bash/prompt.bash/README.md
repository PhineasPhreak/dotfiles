## My Installation :
* Create `~/.config/prompt/` and copy `git-completion.bash` and `prompt.bash`
* Edit the `.bashrc` file with :
  ```bash
    # Use skeswa/prompt
    if [ -f ~/.config/prompt/prompt.bash ]; then
        source ~/.config/prompt/prompt.bash
        source ~/.config/prompt/git-completion.bash
    fi
  ```

## Original Installation :
* See Github : https://github.com/skeswa/prompt