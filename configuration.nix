# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ nixpkgs, lib, config, pkgs, ... }:
let

in
with pkgs; rec
{


  boot.initrd.availableKernelModules = [ "ata_piix" "ohci_pci" "ahci" "mptspi" "mptsas" "sd_mod" "sr_mod" ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
  { device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  swapDevices = [ ];

  nix.maxJobs = lib.mkDefault 2;


# Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
# Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda";
  networking.hostName = "nixos"; # Define your hostname.
#networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

# Select internationalisation properties.
    i18n = {
      consoleFont = "Lat2-Terminus16";
      consoleKeyMap = "us";
      defaultLocale = "en_US.UTF-8";
    };

# Set your time zone.
  time.timeZone = "Europe/Amsterdam";

# List packages installed in system profile. To search by name, run:
# $ nix-env -qaP | grep wget
#	programs.zsh.enable = true;
#	users.extraUsers.root.shell = "/run/current-system/sw/bin/zsh";
#	users.defaultUserShell = "/run/current-system/sw/bin/zsh";


# List services that you want to enable:

# Enable the OpenSSH daemon.
  services.openssh.enable = true;

# Enable CUPS to print documents.
# services.printing.enable = true;

# Enable the X11 windowing system.
  services.xserver.enable = true; 
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "eurosign:e";
  services.xserver.enableTCP = true;
  services.xserver.autorun = true;

# Enable the KDE Desktop Environment.o

  services.xserver.displayManager.kdm.enable = true;
  services.xserver.desktopManager.kde4.enable = true;
#services.xserver.desktopManager.xfce.enable = true;
#services.xserver.displayManager.auto.enable = true;


# Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.guest = {
    isNormalUser = true;
    uid = 1000;
  };
  users.extraUsers.demo = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    openssh.authorizedKeys.keys = [ "ecdsa-sha2-nistp256 
      AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBL2udfmIJxpvfATmS6ZY3it4Y3FOguSi4IRkoJfHHEOEJ5hMiYUxwkFVWnO7oQ8kU+QKzA3RuDmCi/bAQHT2mP8= root@test.nikola.link" ];
  };

  users.extraUsers.root.openssh.authorizedKeys.keys= ["ecdsa-sha2-nistp256 
    AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBL2udfmIJxpvfATmS6ZY3it4Y3FOguSi4IRkoJfHHEOEJ5hMiYUxwkFVWnO7oQ8kU+QKzA3RuDmCi/bAQHT2mP8= root@test.nikola.link"];

#security.grsecurity.enable=true;
#security.grsecurity.config.virtualisationConfig = "guest";
#security.grsecurity.config.system = "desktop";
#security.grsecurity.config.virtualisationSoftware = "virtualbox";
#security.grsecurity.config.hardwareVirtualisation = true;
  virtualisation.virtualbox.guest.enable = true;
#boot.kernelPackages = pkgs.linuxPackages_grsec_desktop_latest;

  security.sudo.configFile=
    ''
    root       ALL=(ALL) SETENV: ALL
    %wheel     ALL=(ALL) SETENV: ALL
    demo       ALL=(ALL) SETENV: ALL
    '';


# The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "16.03";

#	environment.systemPackages = with pkgs; [
#		tmux
#			wget
#	];




  nixpkgs.config.packageOverrides = pkgs : with pkgs; rec {
    emacsEnv = setPrio "9" (
        buildEnv {
        name = "emacs-env";
        ignoreCollisions = true;
        paths = [
        (emacsWithPackages (with emacsPackages; with emacsPackagesNg; [
                            company
                            company-ghc
                            evil
                            evil-leader
#evil-surround
                            flycheck
                            haskell-mode
                            helm
                            markdown-mode
                            monokai-theme
                            org
                            rainbow-delimiters
                            undo-tree
                            use-package
        ]))
        ];
        }
    );
    my_vim = pkgs.neovim.override {

      vimAlias=true;
      configure={
#name = "neovim";

#vimrcConfig.
        customRC = ''
          syntax on
          filetype on
          set expandtab
          set bs=2
          set tabstop=2
          set shiftwidth=2
          set autoindent
          set smartindent
          set smartcase
          set ignorecase
          set modeline
          set nocompatible
          set encoding=utf-8
          set hlsearch
          set history=700
          set t_Co=256
          set tabpagemax=1000
          set ruler
          set nojoinspaces
          set shiftround
          " linebreak on 500 characters
          set lbr
          set tw=500
          " Visual mode pressing * or # searches for the current selection
          " Super useful! From an idea by Michael Naumann
          vnoremap <silent> * :call VisualSelection('f')<CR>
          vnoremap <silent> # :call VisualSelection('b')<CR>
          let mapleader = ","
          " Disable highlight when <leader><cr> is pressed
          map <silent> <leader><cr> :noh<cr>
          " Smart way to move between windows
          map <C-j> <C-W>j
          map <C-k> <C-W>k
          map <C-h> <C-W>h
          map <C-l> <C-W>l
          " I accidentally hit F1 all the time
          imap <F1> <Esc>
          " nice try, Ex mode
          map Q <Nop>
          " who uses semicolon anyway?
          map ; :
          " ==== custom macros ====
          " Delete a function call. example:  floor(int(var))
          "         press when your cursor is       ^        results in:
          "                                   floor(var)
          map <C-H> ebdw%x<C-O>x

          " Insert a timestamp
          nmap <F3> a<C-R>=strftime("%Y-%m-%d %a %I:%M %p")<CR><Esc>
          imap <F3> <C-R>=strftime("%Y-%m-%d %a %I:%M %p")<CR>
          " Toggle paste mode on and off
          map <leader>v :setlocal paste!<cr>
          map <leader>t :tabnew <cr>

          " run ctags in current directory
          filetype plugin on
          map <C-F12> :!ctags -R -I --c++-kinds=+p --fields=+iaS --extra=+q .<CR>
          " Tagbar shortcut
          nmap <F8> :TagbarToggle<CR>

          " CtrlP File finder

          let g:syntastic_cpp_compiler = 'clang++'
          let g:syntastic_cpp_compiler_options = ' -std=c++11'
          let g:syntastic_c_include_dirs = [ 'src', 'build' ]
          let g:syntastic_cpp_include_dirs = [ 'src', 'build' ]
          let g:ycm_autoclose_preview_window_after_completion = 1

          syntax enable
          syntax on
          filetype plugin indent on
          let g:airline#extensions#tabline#enabled = 1
          let g:airline#extensions#tabline#left_sep = ' '
          let g:airline#extensions#tabline#left_alt_sep = '|'
          let mapleader=","
          map <leader>a :NERDTreeToggle<CR>
          nmap <leader>s :w<CR>
          vmap <leader>s <Esc><C-s>gv
          imap <leader>s <Esc><C-s>

          set nocompatible
          set hidden

          nmap <F2> :update<CR>
          vmap <F2> <Esc><F2>gv
          imap <F2> <c-o><F2>
          " Gif config
          map  / <Plug>(easymotion-sn)
          omap / <Plug>(easymotion-tn)

          " These `n` & `N` mappings are options. You do not have to map `n` & `N` to EasyMotion.
          " Without these mappings, `n` & `N` works fine. (These mappings just provide
          " different highlight method and have some other features )
          map  n <Plug>(easymotion-next)
          map  N <Plug>(easymotion-prev)
          " size of a hard tabstop
          " a combination of spaces and tabs are used to simulate tab stops at a width
          " other than the (hard)tabstop
          set softtabstop=2
          autocmd FileType ruby,javascript,css autocmd BufWritePre <buffer> StripWhitespace


          nnoremap <F2> :set invpaste paste?<CR>
          set pastetoggle=<F2>
          set showmode
          set nu
          set laststatus=2
          set ttimeoutlen=50
          nnoremap <Leader>f :Unite -start-insert grep/git:.<CR>
          nnoremap <Leader>g :Unite -start-insert grep/git<CR>
          set clipboard=unnamed
          set tabstop=2 softtabstop=0 expandtab shiftwidth=2 smarttab
          set tabstop=2

          " size of an "indent"
          set shiftwidth=2
          set expandtab


          " Return to last edit position when opening files (You want this!)
          autocmd BufReadPost *
          \ if line("'\"") > 0 && line("'\"") <= line("$") |
          \   exe "normal! g`\"" |
          \ endif
          " Remember info about open buffers on close
          set viminfo^=%


          """"""""""""""""""""""""""""""
          " => Status line
          """"""""""""""""""""""""""""""
          " Always show the status line
          set laststatus=2

          " Format the status line
          set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l




          " Delete trailing white space on save, useful for Python and CoffeeScript ;)
          func! DeleteTrailingWS()
          exe "normal mz"
          %s/\s\+$//ge
          exe "normal `z"
          endfunc
          autocmd BufWrite *.py :call DeleteTrailingWS()
          autocmd BufWrite *.coffee :call DeleteTrailingWS()

          """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
          " => vimgrep searching and cope displaying
          """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
          " When you press gv you vimgrep after the selected text
          vnoremap <silent> gv :call VisualSelection('gv')<CR>

          " Open vimgrep and put the cursor in the right position
          map <leader>g :vimgrep // **/*.<left><left><left><left><left><left><left>

          " Vimgreps in the current file
          map <leader><space> :vimgrep // <C-R>%<C-A><right><right><right><right><right><right><right><right><right>

          " When you press <leader>r you can search and replace the selected text
          vnoremap <silent> <leader>r :call VisualSelection('replace')<CR>

          " Do :help cope if you are unsure what cope is. It's super useful!
          "
          " When you search with vimgrep, display your results in cope by doing:
          "   <leader>cc
          "
          " To go to the next search result do:
          "   <leader>n
          "
          " To go to the previous search results do:
          "   <leader>p
          "
          map <leader>cc :botright cope<cr>
          map <leader>co ggVGy:tabnew<cr>:set syntax=qf<cr>pgg
          map <leader>n :cn<cr>
          map <leader>p :cp<cr>


          """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
          " => Spell checking
          """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
          " Pressing ,ss will toggle and untoggle spell checking
          map <leader>ss :setlocal spell!<cr>

          " Shortcuts using <leader>
          map <leader>sn ]s
          map <leader>sp [s
          map <leader>sa zg
          map <leader>s? z=


          """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
          " => Misc
          """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
          " Remove the Windows ^M - when the encodings gets messed up
          noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

          " Quickly open a buffer for scripbble
          map <leader>q :e ~/buffer<cr>

          " Toggle paste mode on and off
          map <leader>pp :setlocal paste!<cr>



          """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
          " => Helper functions
          """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
          function! CmdLine(str)
          exe "menu Foo.Bar :" . a:str
          emenu Foo.Bar
          unmenu Foo
          endfunction

          function! VisualSelection(direction) range
          let l:saved_reg = @"
          execute "normal! vgvy"

          let l:pattern = escape(@", '\\/.*$^~[]')
          let l:pattern = substitute(l:pattern, "\n$", "", "")

          if a:direction == 'b'
            execute "normal ?" . l:pattern . "^M"
              elseif a:direction == 'gv'
              call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
                                                                     elseif a:direction == 'replace'
                                                                     call CmdLine("%s" . '/'. l:pattern . '/')
                                                                     elseif a:direction == 'f'
                                                                     execute "normal /" . l:pattern . "^M"
                                                                     endif

                                                                     let @/ = l:pattern
                                                                     let @" = l:saved_reg
                                                                     endfunction


                                                                     " Returns true if paste mode is enabled
                                                                     function! HasPaste()
                                                                     if &paste
                                                                     return 'PASTE MODE  '
                                                                     en
                                                                     return ""
                                                                     endfunction

                                                                     " Don't close window, when deleting a buffer
                                                                     command! Bclose call <SID>BufcloseCloseIt()
                                                                     function! <SID>BufcloseCloseIt()
                                                                     let l:currentBufNum = bufnr("%")
                                                                     let l:alternateBufNum = bufnr("#")

                                                                     if buflisted(l:alternateBufNum)
                                                                     buffer #
                                                                     else
                                                                     bnext
                                                                     endif

                                                                     if bufnr("%") == l:currentBufNum
                                                                     new
                                                                     endif

                                                                     if buflisted(l:currentBufNum)
                                                                     execute("bdelete! ".l:currentBufNum)
                                                                     endif
                                                                     endfunction

                                                                     '';

#vimrcConfig.
vam.knownPlugins = pkgs.vimPlugins // ({

# Custom plugins go here.
#
# Note that you can't copy a package from here straight into the vimPlugins
# module without checking if it works, the environment is slightly different
# (for example we have to specify vimUtils.buildVimPluginFrom2Nix here
# instead of just buildVimPluginFrom2Nix).

exampleCustomPackage = pkgs.vimUtils.buildVimPluginFrom2Nix {
name = "unite-grep-vcs";
src = pkgs.fetchgit {
url = "git://github.com/lambdalisue/unite-grep-vcs";
rev = "193e5b67cc06ce1766421025ff19dd99a6778dbd";
sha256 = "1aj03qx16s3hvxjmdv4bp9s3qs2xskczn6yhiy122jklf52ligmh";
};
dependencies = [];
};

});
#vimrcConfig.
vam.pluginDictionaries = [
{ 
names = [
"Syntastic"
"Tagbar"
"ctrlp"
              "vim-addon-nix"
              "youcompleteme"


              "vim-colorschemes"
              "neomake"
              "supertab"
              "Tabular"
              "ctrlp"
              "vim-gitgutter"
              "vinegar"
              "goyo"

              "ghcmod"
              "vimproc"
              "neco-ghc"

              "vim2nix"
              "exampleCustomPackage"
              "nerdtree"
              "unite-vim"
              "easymotion"
              "fugitive"

              ]; }
              ];
              };
};
all = pkgs.buildEnv {
  name = "all";
  paths = [
    my_vim
      steam
      ctags
      youtube-dl
      wolfebin
  ];

};
};
environment.systemPackages = with pkgs; [
  my_vim
  xsel
  pkgs.ctags
];


}

