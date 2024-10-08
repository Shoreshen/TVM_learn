import tvm



print(tvm._ffi.base._LIB)
print('\n'.join(f'{k}: {v}' for k, v in tvm.support.libinfo().items()))
print(tvm.cuda().exist)

n = 1024
A = tvm.te.placeholder((n,), name='A')
B = tvm.te.placeholder((n,), name='B')
C = tvm.te.compute(A.shape, lambda i: A[i] + B[i], name="C")
