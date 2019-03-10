# Video Notes

## `ffmpeg`

```sh
$ man ffmpeg

        -i url (input)
            input file url

        -y (global)
            Overwrite output files without asking.

        -codec[:stream_specifier] codec (input/output,per-stream)
            Select an encoder (when used before an output file) or a decoder (when used
            before an input file) for one or more streams. codec is the name of a
            decoder/encoder or a special value "copy" (output only) to indicate that the
            stream is not to be re-encoded.

            For example

                    ffmpeg -i INPUT -map 0 -c:v libx264 -c:a copy OUTPUT

            encodes all video streams with libx264 and copies all audio streams.

```

Cropping:

    ffmpeg -i in.mp4 -filter:v "crop=out_w:out_h:x:y" out.mp4

>Where the options are as follows:
>
>* out_w is the width of the output rectangle
>* out_h is the height of the output rectangle
>* x and y specify the top left corner of the output rectangle

Cropping (previewing):

    ffplay  -i videos/pitbull-lullaby.mp4  -vf crop="in_w:in_h:0:400"

ffplay  -i videos/pitbull-lullaby.mp4  -vf crop="in_w-33:in_h-33:33:33"

## 

