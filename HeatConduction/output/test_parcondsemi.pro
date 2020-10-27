; 1. plot results, 2. calculate errors, 3. plot errors

; 1. plot results for various resolutions
resdir='test_parcondsemi_results/'

!p.charsize=2
!p.charthick=1

filename = resdir + '40/GM/z*.outs'
func='te bx;by'
plotmode='contbargrid stream2whiteover'
velvector=20
transform='n'
bottomline=1
plottitle="temperature"
multiplot=[2,1,0]
set_device, resdir+'temperature.eps', /eps, /land
loadct,26
dpict=2
animate_data
close_device,/pdf


; 2. calculate errors and save it into a file
openw, 99, resdir + 'error.dat'
printf,99,'parallel heat conduction test'
printf,99,'n error'

; read the last snapshot 
npict=100

filename=resdir+'40/GM/z*.outs'
read_data
printf,99,40,calc_linf(w)

filename=resdir+'80/GM/z*.outs'
read_data
printf,99,80,calc_linf(w)

filename=resdir+'160/GM/z*.outs'
read_data
printf,99,160,calc_linf(w)

close,99

; 3. Create a figure of convergence rates
!p.charsize=2
!p.charthick=1

set_device, resdir + 'error.eps', /eps, /land
logfilename = resdir + 'error.dat'
read_log_data
plot_oo,1/wlog(*,0),(wlog(*,1)),xrange=[1e-3,1e-1],yrange=[1e-3,1e-1],$
        psym=-4,charsize=2,thick=3, $
        xtitle='Grid resolution', $
        ytitle='Maximum absolute error (Linf)', $
        title="parallel heat conduction test"
oplot,[3e-3,3e-1],[1e-3,1e+1],linestyle=2,thick=3
xyouts,0.002,0.01,'2nd order slope',charsize=2,charthick=1
close_device,/pdf

exit
