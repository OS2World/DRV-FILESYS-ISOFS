/* REXX: install-test <ifsfile> <params> : test install of the new ISOFS on a test machine.
   Copies the binaries to C:\ISOFS and replaces the line IFS=C:\sys\bin\STUBFSD.IFS ISOFS of C:\CONFIG.SYS by
   IFS=C:\ISOFS\<ifsfile> ISOFS <params> (the old line stays as a REM line). The source path is the share of the test VM. */
parse arg ifsfile params
call RxFuncAdd 'SysFileDelete','REXXUTIL','SysFileDelete'
src = 'D:\Projects\Drivers\DRV-FILESYS-ISOFS\bin\'
'md C:\ISOFS >nul 2>&1'
'copy' src'isofs.ifs C:\ISOFS\'ifsfile' >nul'
'copy' src'isofsdmn.exe C:\ISOFS >nul'
'copy' src'mapiso.exe C:\ISOFS >nul'
'copy' src'isoinfo.exe C:\ISOFS >nul'
'copy' src'isodrive.exe C:\ISOFS >nul'
'copy' src'isodrive_*.msg C:\ISOFS >nul'
cfg = "C:\CONFIG.SYS"
if stream('C:\CONFIG.ISOFS','c','query exists') = '' then 'copy' cfg 'C:\CONFIG.ISOFS >nul'
n = 0
do while lines(cfg) > 0
  n = n + 1
  l.n = linein(cfg)
end
call lineout cfg
tmp = "C:\CONFIG.NEW"
call SysFileDelete tmp
done = 0
do i = 1 to n
  u = translate(strip(l.i))
  if pos('C:\ISOFS\', u) > 0 then iterate
  if u = 'IFS=C:\SYS\BIN\STUBFSD.IFS ISOFS' | u = 'REM IFS=C:\SYS\BIN\STUBFSD.IFS ISOFS' then do
    call lineout tmp, 'REM IFS=C:\sys\bin\STUBFSD.IFS ISOFS'
    call lineout tmp, 'IFS=C:\ISOFS\'ifsfile 'ISOFS' params
    done = 1
    iterate
  end
  call lineout tmp, l.i
end
call lineout tmp
'copy' tmp cfg '>nul'
say 'isofs cfg done' done ifsfile params
