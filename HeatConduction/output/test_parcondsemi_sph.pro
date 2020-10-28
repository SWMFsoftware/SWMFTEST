; 1. plot results, 2. calculate errors, 3. plot errors

; 1. plot results for various resolutions
resdir='test_parcondsemi_sph_results/'

!p.charsize=2
!p.charthick=1

filename = resdir + '32/GM/x*.outs'
func='te te0'
plotmode='contbargrid stream2whiteover'
velvector=20
transform='n'
bottomline=1
plottitle="temperature"
;multiplot=[2,1,0]
set_device, resdir+'temperature.eps', /eps, /land
loadct,26
npict=3
read_data
plot_data
close_device,/pdf


; 2. calculate errors and save it into a file
openw, 99, resdir + 'error.dat'
printf,99,'parallel heat conduction test in spherical coordinates'
printf,99,'n error'

; read the last snapshot 
npict=3

filename=resdir+'8/GM/x*.outs'
read_data
printf,99,16,(total(abs(w(*,*,0) - w(*,*,1)))) / total(abs(w(*,*,1)))

filename=resdir+'16/GM/x*.outs'
read_data
printf,99,32,(total(abs(w(*,*,0) - w(*,*,1)))) / total(abs(w(*,*,1)))

filename=resdir+'32/GM/x*.outs'
read_data
printf,99,64,(total(abs(w(*,*,0) - w(*,*,1)))) / total(abs(w(*,*,1)))

close,99

; 3. Create a figure of convergence rates
!p.charsize=2
!p.charthick=1

set_device, resdir + 'error.eps', /eps, /land
logfilename = resdir + 'error.dat'
read_log_data
plot_oo,1/wlog(*,0),(wlog(*,1)),xrange=[1e-2,1e-1],yrange=[1e-3,2e-1],$
        psym=-4,charsize=2,thick=3, $
        xtitle='Grid resolution', $
        ytitle='relative L1 error', $
        title="spherical field-aligned heat conduction test"
oplot,[1e-2,1e-1],[1e-3,1e-1],linestyle=2,thick=3
xyouts,0.04,0.009,'2nd order slope',charsize=2,charthick=1

close_device,/pdf

exit
