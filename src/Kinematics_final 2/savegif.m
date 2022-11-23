% Used to save the plot as a GIF

function savegif(h,filename,iter)

frame = getframe(h);
im = frame2im(frame);
[imind,cm] = rgb2ind(im,256);

if iter == 1
    imwrite(imind,cm,filename,'gif', 'Loopcount',inf);
else
    imwrite(imind,cm,filename,'gif','WriteMode','append');
end

end