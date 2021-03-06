# NOTES


## `shake` (package)

### ``

```haskell
```

### `command`

`command`:

```haskell
command :: CmdResult r => [CmdOption] -> String -> [String] -> Action r
```

### `CmdOption`

```haskell
-- | Options passed to 'command' or 'cmd' to control how processes are executed.

data CmdOption

    = Cwd         FilePath          -- ^ Change the current directory in the spawned process. By default uses this processes current directory.

    | Env         [(String,String)] -- ^ Change the environment variables in the spawned process. By default uses this processes environment.

    | AddEnv      String String     -- ^ Add an environment variable in the child process.

    | RemEnv      String            -- ^ Remove an environment variable from the child process.

    | AddPath     [String] [String] -- ^ Add some items to the prefix and suffix of the @$PATH@ variable.

    | Stdin       String            -- ^ Given as the @stdin@ of the spawned process. By default the @stdin@ is inherited.

    | StdinBS     LBS.ByteString    -- ^ Given as the @stdin@ of the spawned process.

    | FileStdin   FilePath          -- ^ Take the @stdin@ from a file.

    | Shell                         -- ^ Pass the command to the shell without escaping - any arguments will be joined with spaces. By default arguments are escaped properly.

    | BinaryPipes                   -- ^ Treat the @stdin@\/@stdout@\/@stderr@ messages as binary. By default 'String' results use text encoding and 'ByteString' results use binary encoding.

    | Traced      String            -- ^ Name to use with 'traced', or @\"\"@ for no tracing. By default traces using the name of the executable.

    | Timeout     Double            -- ^ Abort the computation after N seconds, will raise a failure exit code. Calls 'interruptProcessGroupOf' and 'terminateProcess', but may sometimes fail to abort the process and not timeout.

    | WithStdout  Bool              -- ^ Should I include the @stdout@ in the exception if the command fails? Defaults to 'False'.

    | WithStderr  Bool              -- ^ Should I include the @stderr@ in the exception if the command fails? Defaults to 'True'.

    | EchoStdout  Bool              -- ^ Should I echo the @stdout@? Defaults to 'True' unless a 'Stdout' result is required or you use 'FileStdout'.

    | EchoStderr  Bool              -- ^ Should I echo the @stderr@? Defaults to 'True' unless a 'Stderr' result is required or you use 'FileStderr'.

    | FileStdout  FilePath          -- ^ Should I put the @stdout@ to a file.

    | FileStderr  FilePath          -- ^ Should I put the @stderr@ to a file.

    | AutoDeps                      -- ^ Compute dependencies automatically.
```

### ``

```haskell
```


## `pandoc` (program)

e.g. 

```sh
pandoc  --standalone  --from markdown  --to html  --css X.css  Y.md   >  Z.html
```



## CC-BY-NC-SA-4.0 (license)

<https://creativecommons.org/licenses/by-nc-sa/4.0/legalcode>
<https://spdx.org/licenses/CC-BY-NC-SA-4.0.html>

"CC-BY-NC-SA-4.0" abbreviates :Creative Commons Attribution Non Commercial Share Alike 4.0 International".


## Tufte

<https://edwardtufte.github.io/tufte-css/>

>A given document can have multiple articles in it; for example, on a blog that shows the text of each article one after another as the reader scrolls, each post would be contained in an `<article>` element, possibly with one or more `<section>`s within.



## 

