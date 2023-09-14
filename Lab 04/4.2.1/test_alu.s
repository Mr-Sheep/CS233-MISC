# feel free to add or change any of the test cases to compile

.text
main:
   addi  $6, $0, 100         # $6  =   100 (0x64)
   addi  $7, $6, 155         # $7  =   255 (0xff)
   sll   $11, $7, 12         # $11 =   0xff000
   add   $8, $6, $6          # $8  =   200 (0xc8)
   add   $9, $6, $6          # $9  =   200 (0xc8)
   srl   $12, $7, 1          # $12 =   0x7f
   sra   $13, $7, 1          # $13 =   0x7f
   
   addi  $15, $0, 4294967295 # $15 = (0xffffffff)
   sra   $16, $15, 1         # $16 = (0xffffffff)
   srl   $17, $15, 1         # $17 = (0x7fffffff)
   sra   $18, $15, 20        # $18 = (0xffffffff)