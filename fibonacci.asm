mov A, 1
mov B, 1
label:
mov D, A
addu A, B
mov B, D
addu C, 1
mov D, 11
cmp C, D
jl label
halt