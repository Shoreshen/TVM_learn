# $@  表示目标文件
# $^  表示所有的依赖文件
# $<  表示第一个依赖文件
# $?  表示比目标还要新的依赖文件列表
# export PYTHONPATH=$TVM_HOME/python:${PYTHONPATH}
# export TVM_HOME=./TVM
BRANCH = $(shell git symbolic-ref --short HEAD)
PW = $(shell cat ~/文档/PW)
# tvm ====================================================================================
install_deps:
	pip install numpy decorator attrs tornado psutil xgboost cloudpickle typing_extensions packaging -i https://pypi.tuna.tsinghua.edu.cn/simple
config_tvm:
	cmake -G Ninja -B build CMAKE_BUILD_TYPE=Debug USE_LLVM="llvm-config --ignore-libllvm --link-static" USE_CUDA=ON USE_CUBLAS=ON USE_CUDNN=ON USE_CUTLASS=ON HIDE_PRIVATE_SYMBOLS=ON
build_tvm:
	cd TVM/build && ninja
# git ====================================================================================
tvm_update:
	cd TVM && git pull
	cd TVM && git submodule update --recursive
commit:
	git add -A
	@echo "Please type in commit comment: "; \
	read comment; \
	git commit -m"$$comment"
sync: commit
	git push -u origin $(BRANCH)
reset_hard:
	git fetch && git reset --hard origin/$(BRANCH)

PHONY += commit sync sub_pull
