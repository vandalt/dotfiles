return {
  {
    "linux-cultist/venv-selector.nvim",
    opts = {
      anaconda_base_path = os.getenv("HOME") .. "./miniforge3",
      anaconda_envs_path = os.getenv("HOME") .. "./miniforge3/envs",
    },
  },
}
