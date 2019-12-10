export PROJ_DIR=$(realpath $(dirname $0)/..)
export PROJ_NAME=$(basename $PROJ_DIR)
export WORK_DIR=/home/jovyan/work/$PROJ_NAME

run_py_script()
{
  echo "Running $1..."
  docker run -it --rm \
         --mount type=bind,src=$PROJ_DIR/data,dst=$WORK_DIR/data \
         --mount type=bind,src=$PROJ_DIR/docs,dst=$WORK_DIR/docs \
         -w $WORK_DIR/python $PROJ_NAME ./$1
}
