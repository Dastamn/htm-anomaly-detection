DIR="./static"
RELEASE_VERSION="2.1.16"

if [ -d venv ]; then
    echo "Reseting 'venv'..."
    rm -rf venv
fi

python -m venv venv

if [ -d $DIR ]; then
    printf "Deleting '%s'..." "$DIR"
    rm -rf $DIR
fi

case $(uname -s) in
    Linux*)     dist=linux64;ext=.tar.gz;;
    Darwin*)    dist=darwin64;ext=.tar.gz;;
    *)          dist=windows64;ext=.zip
esac

FILENAME="htm_core-v${RELEASE_VERSION}-${dist}"
URL="https://github.com/htm-community/htm.core/releases/download/v${RELEASE_VERSION}/${FILENAME}${ext}"

printf "Downloading %s...\n" "$URL"

mkdir $DIR && cd $DIR && { curl -OL $URL ; cd -; }

for file in ${DIR}/*.tar.gz ${DIR}/*.zip; do

    if [ -f "$file" ]; then
        printf "Decompressing %s into %s\n" "$file" "$DIR"
        case $file in
            *.tar.gz) tar -xz -f "$file" -C "$DIR" ;;
            *.zip)    unzip      "$file" -d "$DIR" ;;
        esac

        wheel=$(ls -1 ${DIR}/${FILENAME}/py/*.whl)

        (
            printf "Installing pip packages...\n"
            source ./venv/Scripts/activate
            pip install $wheel
            pip install -r requirements.txt
        )
        break
    fi
   
done