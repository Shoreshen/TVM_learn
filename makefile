# $@  表示目标文件
# $^  表示所有的依赖文件
# $<  表示第一个依赖文件
# $?  表示比目标还要新的依赖文件列表
BRANCH = $(shell git symbolic-ref --short HEAD)
PW = $(shell cat ~/文档/PW)
# tvm ====================================================================================
install_deps:
	pip install numpy decorator attrs tornado psutil xgboost cloudpickle typing_extensions packaging -i https://pypi.tuna.tsinghua.edu.cn/simple
config_tvm:
	- cd TVM && mkdir build
	cp TVM/cmake/config.cmake TVM/build
	echo "set(CMAKE_BUILD_TYPE Debug)" >> TVM/build/config.cmake
	echo "set(USE_LLVM \"/home/shore/文档/projects/llvm_learn/llvm-project/build/bin/llvm-config --ignore-libllvm --link-static\")" >> TVM/build/config.cmake
	echo "set(HIDE_PRIVATE_SYMBOLS ON)" >> TVM/build/config.cmake
	echo "set(USE_CUDA   ON)" >> TVM/build/config.cmake
	echo "set(USE_METAL  OFF)" >> TVM/build/config.cmake
	echo "set(USE_VULKAN OFF)" >> TVM/build/config.cmake
	echo "set(USE_OPENCL OFF)" >> TVM/build/config.cmake
	echo "set(USE_CUBLAS ON)" >> TVM/build/config.cmake
	echo "set(USE_CUDNN  ON)" >> TVM/build/config.cmake
	echo "set(USE_CUTLASS OFF)" >> TVM/build/config.cmake
	cd TVM/build && cmake .. 
build_tvm:
	cd TVM/build && cmake --build . --parallel 16
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
