#!/usr/bin/env bash

set -o noclobber -o noglob -o nounset -o pipefail
IFS=$'\n'

## Script arguments
FILE_PATH="${1}" # Full path of the highlighted file
PV_WIDTH="${2}"  # Width of the preview pane (number of fitting characters)
## shellcheck disable=SC2034 # PV_HEIGHT is provided for convenience and unused
# PV_HEIGHT="${3}"        # Height of the preview pane (number of fitting characters)
IMAGE_CACHE_PATH="${4}" # Full path that should be used to cache image preview
PV_IMAGE_ENABLED="${5}" # 'True' if image previews are enabled, 'False' otherwise.

FILE_EXTENSION="${FILE_PATH##*.}"
FILE_EXTENSION_LOWER="$(printf "%s" "${FILE_EXTENSION}" | tr '[:upper:]' '[:lower:]')"

HIGHLIGHT_SIZE_MAX=262143 # 256KiB
HIGHLIGHT_TABWIDTH=${HIGHLIGHT_TABWIDTH:-8}
HIGHLIGHT_STYLE=${HIGHLIGHT_STYLE:-pablo}
HIGHLIGHT_OPTIONS="--replace-tabs=${HIGHLIGHT_TABWIDTH} --style=${HIGHLIGHT_STYLE} ${HIGHLIGHT_OPTIONS:-}"
PYGMENTIZE_STYLE=${PYGMENTIZE_STYLE:-autumn}
OPENSCAD_IMGSIZE=${RNGR_OPENSCAD_IMGSIZE:-1000,1000}
OPENSCAD_COLORSCHEME=${RNGR_OPENSCAD_COLORSCHEME:-Tomorrow Night}

handle_extension() {
  case "${FILE_EXTENSION_LOWER}" in
  a | ace | alz | arc | arj | bz | bz2 | cab | cpio | deb | gz | jar | lha | lz | lzh | lzma | lzo | \
    rpm | rz | t7z | tar | tbz | tbz2 | tgz | tlz | txz | tZ | tzo | war | xpi | xz | Z | zip)
    atool --list -- "${FILE_PATH}" && exit 5
    bsdtar --list --file "${FILE_PATH}" && exit 5
    exit 1
    ;;
  rar)
    unrar lt -p- -- "${FILE_PATH}" && exit 5
    exit 1
    ;;
  7z)
    7z l -p -- "${FILE_PATH}" && exit 5
    exit 1
    ;;
  md)
    glow "${FILE_PATH}" && exit 5
    exit 1
    ;;
  py | js | rb | sql)
    batcat --theme="Dracula" "${FILE_PATH}" && exit 5
    exit 1
    ;;
  pdf)
    pdftotext -l 10 -nopgbrk -q -- "${FILE_PATH}" - |
      fmt -w "${PV_WIDTH}" && exit 5
    mutool draw -F txt -i -- "${FILE_PATH}" 1-10 |
      fmt -w "${PV_WIDTH}" && exit 5
    exiftool "${FILE_PATH}" && exit 5
    exit 1
    ;;

  torrent)
    transmission-show -- "${FILE_PATH}" && exit 5
    exit 1
    ;;

  odt | ods | odp | sxw)
    odt2txt "${FILE_PATH}" && exit 5
    pandoc -s -t markdown -- "${FILE_PATH}" && exit 5
    exit 1
    ;;

  xlsx)
    xlsx2csv -- "${FILE_PATH}" && exit 5
    exit 1
    ;;

  htm | html | xhtml)
    w3m -dump "${FILE_PATH}" && exit 5
    lynx -dump -- "${FILE_PATH}" && exit 5
    elinks -dump "${FILE_PATH}" && exit 5
    pandoc -s -t markdown -- "${FILE_PATH}" && exit 5
    ;;

  json)
    jq --color-output . "${FILE_PATH}" && exit 5
    python -m json.tool -- "${FILE_PATH}" && exit 5
    ;;

  dff | dsf | wv | wvc)
    mediainfo "${FILE_PATH}" && exit 5
    exiftool "${FILE_PATH}" && exit 5
    ;;
  esac
}

handle_image() {
  local DEFAULT_SIZE="1920x1080"

  local mimetype="${1}"
  case "${mimetype}" in
  ## SVG
  image/svg+xml | image/svg)
    convert -- "${FILE_PATH}" "${IMAGE_CACHE_PATH}" && exit 6
    exit 1
    ;;

  ## DjVu
  image/vnd.djvu)
    ddjvu -format=tiff -quality=90 -page=1 -size="${DEFAULT_SIZE}" \
      - "${IMAGE_CACHE_PATH}" <"${FILE_PATH}" &&
      exit 6 || exit 1
    ;;

  ## Image
  image/*)
    local orientation
    orientation="$(identify -format '%[EXIF:Orientation]\n' -- "${FILE_PATH}")"
    if [[ -n "$orientation" && "$orientation" != 1 ]]; then
      convert -- "${FILE_PATH}" -auto-orient "${IMAGE_CACHE_PATH}" && exit 6
    fi

    exit 7
    ;;

  video/*)
    # Thumbnail
    ffmpegthumbnailer -i "${FILE_PATH}" -o "${IMAGE_CACHE_PATH}" -s 0 && exit 6
    exit 1
    ;;

  application/pdf)
    pdftoppm -f 1 -l 1 \
      -scale-to-x "${DEFAULT_SIZE%x*}" \
      -scale-to-y -1 \
      -singlefile \
      -jpeg -tiffcompression jpeg \
      -- "${FILE_PATH}" "${IMAGE_CACHE_PATH%.*}" &&
      exit 6 || exit 1
    ;;

  application/epub+zip | application/x-mobipocket-ebook | \
    application/x-fictionbook+xml)
    # ePub (using https://github.com/marianosimone/epub-thumbnailer)
    epub-thumbnailer "${FILE_PATH}" "${IMAGE_CACHE_PATH}" \
      "${DEFAULT_SIZE%x*}" && exit 6
    ebook-meta --get-cover="${IMAGE_CACHE_PATH}" -- "${FILE_PATH}" \
      >/dev/null && exit 6
    exit 1
    ;;

  application/font* | application/*opentype)
    preview_png="/tmp/$(basename "${IMAGE_CACHE_PATH%.*}").png"
    if fontimage -o "${preview_png}" \
      --pixelsize "120" \
      --fontname \
      --pixelsize "80" \
      --text "  ABCDEFGHIJKLMNOPQRSTUVWXYZ  " \
      --text "  abcdefghijklmnopqrstuvwxyz  " \
      --text "  0123456789.:,;(*!?') ff fl fi ffi ffl  " \
      --text "  The quick brown fox jumps over the lazy dog.  " \
      "${FILE_PATH}"; then
      convert -- "${preview_png}" "${IMAGE_CACHE_PATH}" &&
        rm "${preview_png}" &&
        exit 6
    else
      exit 1
    fi
    ;;

  application/zip | application/x-rar | application/x-7z-compressed | \
    application/x-xz | application/x-bzip2 | application/x-gzip | application/x-tar)
    local fn=""
    local fe=""
    local zip=""
    local rar=""
    local tar=""
    local bsd=""
    case "${mimetype}" in
    application/zip) zip=1 ;;
    application/x-rar) rar=1 ;;
    application/x-7z-compressed) ;;
    *) tar=1 ;;
    esac
    { [ "$tar" ] && fn=$(tar --list --file "${FILE_PATH}"); } ||
      { fn=$(bsdtar --list --file "${FILE_PATH}") && bsd=1 && tar=""; } ||
      { [ "$rar" ] && fn=$(unrar lb -p- -- "${FILE_PATH}"); } ||
      { [ "$zip" ] && fn=$(zipinfo -1 -- "${FILE_PATH}"); } || return

    fn=$(echo "$fn" | python -c "import sys; import mimetypes as m; \
                     [ print(l, end='') for l in sys.stdin if \
                       (m.guess_type(l[:-1])[0] or '').startswith('image/') ]" |
      sort -V | head -n 1)
    [ "$fn" = "" ] && return
    [ "$bsd" ] && fn=$(printf '%b' "$fn")

    [ "$tar" ] && tar --extract --to-stdout \
      --file "${FILE_PATH}" -- "$fn" >"${IMAGE_CACHE_PATH}" && exit 6
    fe=$(echo -n "$fn" | sed 's/[][*?\]/\\\0/g')
    [ "$bsd" ] && bsdtar --extract --to-stdout \
      --file "${FILE_PATH}" -- "$fe" >"${IMAGE_CACHE_PATH}" && exit 6
    [ "$bsd" ] || [ "$tar" ] && rm -- "${IMAGE_CACHE_PATH}"
    [ "$rar" ] && unrar p -p- -inul -- "${FILE_PATH}" "$fn" > \
      "${IMAGE_CACHE_PATH}" && exit 6
    [ "$zip" ] && unzip -pP "" -- "${FILE_PATH}" "$fe" > \
      "${IMAGE_CACHE_PATH}" && exit 6
    [ "$rar" ] || [ "$zip" ] && rm -- "${IMAGE_CACHE_PATH}"
    ;;
  esac

  openscad_image() {
    TMPPNG="$(mktemp -t XXXXXX.png)"
    openscad --colorscheme="${OPENSCAD_COLORSCHEME}" \
      --imgsize="${OPENSCAD_IMGSIZE/x/,}" \
      -o "${TMPPNG}" "${1}"
    mv "${TMPPNG}" "${IMAGE_CACHE_PATH}"
  }

  case "${FILE_EXTENSION_LOWER}" in
  csg | scad)
    openscad_image "${FILE_PATH}" && exit 6
    ;;
  3mf | amf | dxf | off | stl)
    openscad_image <(echo "import(\"${FILE_PATH}\");") && exit 6
    ;;
  esac
}

handle_mime() {
  local mimetype="${1}"
  case "${mimetype}" in
  ## RTF and DOC
  text/rtf | *msword)
    catdoc -- "${FILE_PATH}" && exit 5
    exit 1
    ;;

  *wordprocessingml.document | */epub+zip | */x-fictionbook+xml)
    ## Preview as markdown conversion
    pandoc -s -t markdown -- "${FILE_PATH}" && exit 5
    exit 1
    ;;

  ## XLS
  *ms-excel)
    xls2csv -- "${FILE_PATH}" && exit 5
    exit 1
    ;;

  ## Text
  text/* | */xml)
    ## Syntax highlight
    if [[ "$(stat --printf='%s' -- "${FILE_PATH}")" -gt "${HIGHLIGHT_SIZE_MAX}" ]]; then
      exit 2
    fi
    if [[ "$(tput colors)" -ge 256 ]]; then
      local pygmentize_format='terminal256'
      local highlight_format='xterm256'
    else
      local pygmentize_format='terminal'
      local highlight_format='ansi'
    fi
    env HIGHLIGHT_OPTIONS="${HIGHLIGHT_OPTIONS}" highlight \
      --out-format="${highlight_format}" \
      --force -- "${FILE_PATH}" && exit 5
    env COLORTERM=8bit bat --color=always --style="plain" \
      -- "${FILE_PATH}" && exit 5
    pygmentize -f "${pygmentize_format}" -O "style=${PYGMENTIZE_STYLE}" \
      -- "${FILE_PATH}" && exit 5
    exit 2
    ;;

  ## DjVu
  image/vnd.djvu)
    ## Preview as text conversion (requires djvulibre)
    djvutxt "${FILE_PATH}" | fmt -w "${PV_WIDTH}" && exit 5
    exiftool "${FILE_PATH}" && exit 5
    exit 1
    ;;

  ## Image
  image/*)
    ## Preview as text conversion
    # img2txt --gamma=0.6 --width="${PV_WIDTH}" -- "${FILE_PATH}" && exit 4
    exiftool "${FILE_PATH}" && exit 5
    exit 1
    ;;

  ## Video and audio
  video/* | audio/*)
    mediainfo "${FILE_PATH}" && exit 5
    exiftool "${FILE_PATH}" && exit 5
    exit 1
    ;;
  esac
}

handle_fallback() {
  echo '----- File Type Classification -----' && file --dereference --brief -- "${FILE_PATH}" && exit 5
  exit 1
}

MIMETYPE="$(file --dereference --brief --mime-type -- "${FILE_PATH}")"
if [[ "${PV_IMAGE_ENABLED}" == 'True' ]]; then
  handle_image "${MIMETYPE}"
fi

handle_extension
handle_mime "${MIMETYPE}"
handle_fallback

# exit 1
