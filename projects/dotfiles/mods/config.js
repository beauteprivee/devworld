module.exports = {
  brew: [
    // http://conqueringthecommandline.com/book/ack_ag
    'ack',
    'ag',
    // alternative to `cat`: https://github.com/sharkdp/bat
    'bat',
    // Install GNU core utilities (those that come with macOS are outdated)
    // Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
    'coreutils',
    'dos2unix',
    // Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed
    'findutils',
    // 'fortune',
    'fzf',
    'readline', // ensure gawk gets good readline
    'gawk',
    // http://www.lcdf.org/gifsicle/ (because I'm a gif junky)
    'gifsicle',
    'gnupg',
    // Install GNU `sed`, overwriting the built-in `sed`
    // so we can do "sed -i 's/foo/bar/' file" instead of "sed -i '' 's/foo/bar/' file"
    'gnu-sed --with-default-names',
    // upgrade grep so we can get things like inverted match (-v)
    'grep --with-default-names',
    // better, more recent grep
    'homebrew/dupes/grep',
    // https://github.com/jkbrzt/httpie
    'httpie',
    // jq is a sort of JSON grep
    'jq',
    // Mac App Store CLI: https://github.com/mas-cli/mas
    'mas',
    // Install some other useful utilities like `sponge`
    'moreutils',
    'nmap',
    'openconnect',
    'reattach-to-user-namespace',
    // better/more recent version of screen
    'homebrew/dupes/screen',
    'tmux',
    'todo-txt',
    'tree',
    'ttyrec',
    // better, more recent vim
    'vim --with-client-server --with-override-system-vi',
    'watch',
    // Install wget with IRI support
    'wget --enable-iri',

    // CUSTOM Devworld stuff:
    'ssh-copy-id',
    'cowsay',
    'openssl',
    'pv',
    'wrk',
    'composer',
    'mcrypt',
    'docker-compose',
    'git',
    'git-flow',
    'git-flow-avh',
    'bower',
    'fontconfig',
    'zsh',
    'ruby',
    'bash-completion',
    'chromedriver'
  ],
  cask: [
    //'adium',
    //'amazon-cloud-drive',
    //'atom',
    // 'box-sync',
    //'comicbooklover',
    //'diffmerge',
    //'docker', // docker for mac
    //'dropbox',
    //'evernote',
    'flux',
    //'gpg-suite',
    //'ireadfast',
    'iterm2',
    //'little-snitch',
    'macbreakz',
    'micro-snitch',
    //'signal',
    //'macvim',
    //'sizeup',
    //'sketchup',
    //'slack',
    //'the-unarchiver',
    //'torbrowser',
    //'transmission',
    //'visual-studio-code',
    //'vlc',
    //'xquartz',

    // CUSTOM Devworld stuff:
    'gpg-suite-no-mail',
    'dash',
    'iterm2',
    'docker',
    'kitematic',
    'livereload',
    'hyperswitch',
    'firefox',
    'google-chrome',
    'safari-technology-preview',
    'slack',
    'mysqlworkbench',
    'atom',
    'filezilla',
    'keka',
    'phpstorm',
    'royal-tsx',
    'bbedit',
    'virtualbox',
    'squidman',
    'viscosity',
    'microsoft-office',
    'font-fontawesome',
    'font-awesome-terminal-fonts',
    'font-hack',
    'font-inconsolata-dz-for-powerline',
    'font-inconsolata-g-for-powerline',
    'font-inconsolata-for-powerline',
    'font-roboto-mono',
    'font-roboto-mono-for-powerline',
    'font-source-code-pro',
    'spotify',
    'postman',
    'sourcetree',
    'skype',
    'alfred',
    'spectacle',
    'homebrew/cask-versions/java8',
    'android-sdk',
    'android-platform-tools'
  ],
  gem: [
    'docker-sync',
    'git-up'
  ],
  npm: [
    'browser-sync',
    'eslint',
    'instant-markdown-d',
    // 'gulp',
    'npm-check-updates',
    'prettyjson',
    'trash',
    'vtop'
    // ,'yo'
  ]
};
