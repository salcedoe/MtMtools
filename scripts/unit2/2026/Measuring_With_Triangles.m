%[text] %[text:anchor:T_B9F2EF3E] # Measuring with Triangles
%[text] %[text:anchor:H_BF93AA90] ## Triangles
%[text] Triangles are made up of three vertices. The following matrix V has two columns and three rows. 
%[text] - Column 1 = x coordinates
%[text] - Column 2 = y coordinates \
clearvars
close all
V = [0 0; 3 0; 3 4] 
%%
%[text] %[text:anchor:H_8414DFA2] ### Plot vertices 
%[text] %[text:anchor:H_5347F6D0] We can use the function **scatter** to plot our triangle:
figure;
scatter(V(:,1),V(:,2),'filled'); % plot the vertices
xlabel('x'); ylabel('y'); % label axes
grid on % display grid on plot
axis([-1 9 -1 9]) % set the x and y-limit
%%
%[text] %[text:anchor:H_E302A79F] ### Plot Face using patch
%[text] Alternatively, we can use the function **patch** to plot the interior of the triangle. The interior of a triangle is called the face.
patch(V(:,1),V(:,2),'cyan','LineStyle',':') % fill in the triangle
ht = text(1, 2.5, 'c = ?'); % add text to the figure
%[text] - What is the length of c? \
%%
%[text] %[text:anchor:H_2C0C7F45] ### Length of the Hypotenuse
%[text] We can use the Pythagorean theorem to calculate the length of the hypotenuse:
%[text] ![](text:image:5df9)
%[text] $c=\\sqrt{\\;\\left(a^2 +b^2 \\right)}${"editStyle":"visual"}
%[text] Since we just have the vertices, we need to first calculate the lengths of a and b:
%[text] - $a=x\_2 -x\_1 =3-0${"editStyle":"visual"}
%[text] - $b=y\_2 -y\_1 =4-0${"editStyle":"visual"} \
a = 3-0; % length of a
b = 4-0; % length of b
c = sqrt(a^2+b^2) % length of c
%%
%[text] The function **hypot** calculates the same thing by simply inputting a and b
c = hypot(a,b)
%%
%[text] %[text:anchor:H_8F768FC8] ### Calculating the hypotenuse, take 2
%[text] Instead of manually calculating the length of each side that you want to measure, you can use the function **diff** to automate the process. The function **diff** subtracts consecutive rows. Recall that our matrix v has the following values
V
%[text] So, the  difference between sequential rows is as follows:
%[text] ```matlabCodeExample
%[text] 0 0
%[text] 3 0
%[text] ___
%[text] 3 0
%[text] 
%[text] 3 0
%[text] 3 4
%[text] ___
%[text] 0 4
%[text] ```
%[text] 
%[text] 
%%
%[text] Which is what you get when you use the function **diff**
D = diff(V) % the second input
%[text] - Notice that *D* has one less row than *V* \
%%
%[text] If we run **diff** again, we get the lengths of *a* and *b*
D = diff(D)
%%
%[text] which we can then just plug into **hypot**
c = hypot(D(1), D(2))
%%
%[text] %[text:anchor:H_67DFB188] ## Measuring the distance between two points
%[text] Consider the following two points
clearvars
close all
pts = [2 3; 5 7]; % (2,3) & (5,7)

figure;
scatter(pts(:,1), pts(:,2),'*');
xlabel('x'); ylabel('y');
axis([0 8 0 8])
grid on
%[text] - How far apart are these two points? \
%%
%[text] Hint: visualize a triangle
hp = patch([2 5 5],[3 3 7],'cyan','LineStyle',':','FaceAlpha',0.25);
text([3.5 5.25 3.5],[2.5 5 5.5],{'a','b','c'})
grid on
%[text] So, to calculate the distance between two points, we simply need to recreate a triangle and calculate the hypotenuse (c), using the Pythagorean theorem. This is also known as the Euclidean distance.
%[text] We can calculate the lengths of *a* and *b* as follows:
%[text] $a=\\textrm{x2}-\\textrm{x1}=5-2=3${"editStyle":"visual"}
%[text] $b=\\textrm{y2}-\\textrm{y1}=6-2=4${"editStyle":"visual"}
%%
%[text] %[text:anchor:H_F463386C] ### Calculating side lengths
%[text] The function **diff** simplifies calculating *a* and *b*
D = diff(pts)
%[text] And **hypot** can calculate the distance
pt_dist = hypot(D(1), D(2))
%%
%[text] %[text:anchor:H_677A068D] ### Length of a line
%[text] Consider the following line
pts = [0 0; 1 3; 2 1; 3 6; 4 7]

figure; 
plot(pts(:,1), pts(:,2),'*:')
xlabel('x'); ylabel('y');
axis equal
axis([-1 5 -1 8])
grid on
%[text] - How long is this line?
%[text] - Hint: its triangles all the way down \
%%
%[text] %[text:anchor:H_A0D6BB33] ### Calculate the length of each line segment
%[text] %[text:anchor:H_657CA49F] #### 1. Subtract consecutive point pairs
%[text] ```
%[text] x2-x1, x3-x2, x4-x3,...
%[text] y2-y1, y3-y2, y4-y3,...
%[text] ```
%[text] - this gets us the "sides of the triangles for each pair of points \
D = diff(pts) % sides of triangles
%[text] #### 2. Calculate the hypotenuses of these sides
%[text] %[text:anchor:H_EA0D071D] - This gets us the length of the line segments \
H = hypot(D(:,1), D(:,2)) % hypotenuses
%[text] **3. Add up the lengths of the line segments**
L = sum(H) % add up line segments = total length of line
%%
%[text] Using MATLAB math gives us the same answer (in one line)
%[text] $\\textrm{Distance}=\\sum\_n \\sqrt{\\;{\\left(x\_{n+1} -x\_n \\right)}^2 +{\\left(y\_{n+1} -y\_n \\right)}^2 }${"editStyle":"visual"}
L = sum(sqrt(sum(diff(pts).^2,2))) % length of line
%%
%[text] %[text:anchor:T_368B5803] # Distance Transform 
%[text] The distance transformation is very useful for measuring the distances in an image. It calculates the distance (in pixels) from the TRUEs in a binary image. The default measurement is to use the Pythagorean theorem (or Euclidean distance) to calculate the distance. 
%[text] First, a simple example. We will create a 5X5 logical array ***M*** with a TRUE at its center. Then we will calculate the Distance Transform of ***M*** using the function **bwdist.**
% create matrix
M = zeros(5);
M(3,3) = 1
% display
figure;

nexttile
imshow(M)
title('Logical Array M')

nexttile
B = bwdist(M)
heatmap(B)
title('distance transform')
%[text] - B is the distance transform.
%[text] - B is a matrix the same size as M.
%[text] - Every element of B contains the calculated distance in pixels from the TRUE found in ***M***.
%[text] - Notice that the corresponding location in ***B*** to where the TRUE is found in ***M*** contains a zero. There is zero distance from the TRUE in this location.
%[text] - Diagonals are calculated using Euclidean Distance: \
%[text]  $A^2 +B^2 =C^2${"editStyle":"visual"}
%%
%[text] %[text:anchor:H_CF45EE32] ### Distance transform with multiple connected components
%[text] What happens when we calculate the distance transform in a logical array that has multiple TRUES?
binmat = false(100);
binmat([2425 2475 7425 7475]) = true;
B2 = bwdist(binmat);

figure;
nexttile; 
imshow(binmat); colorbar
title('Logical Array')

nexttile; 
imshow(B2,parula(35))
title('Distance transform')
colorbar
impixelinfo
%[text] - Notice the distance transform has zeros (blue) in the regions corresponding to the connected components
%[text] - The furthest distance calculated is ~14 pixels (bright spots). This is the farthest distance from a TRUE to another TRUE or to an edge of the image.
%[text] - Notice the feathering affect just outside the squares \

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
%[text:image:5df9]
%   data: {"align":"baseline","height":108,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAALgAAACpCAYAAACYuff5AAASlElEQVR4Ae2d648VRRbATeQP0GiyfvHLbjR+2GggfjKuH3bNrImsn3RjdkI2m43GjVExZl0SJZuNazT7UImGLOpCVAR5ryOM8hjAQXnNyGuAGQZ5CAyDODAgM8A8a\/tXd87Qc7l37r19u26\/TidFNz23q6vO+fXpU6e6qm4wuqkEUiyBG1JcN62aSsAo4ApB2RLYd7THnO3tL\/v3cfihAh4HLcS8DKOjI2bz3i7z\/LutZlv7mZiXdmLxFPCJ8tD\/5UngwqV+s3DjUbN+70WzuLnbrN1xOO8X8f6vAh5v\/URauo6T58x\/1x0xWzv6zaVhYwFfvaXNmNGhSMtVyc0V8EqklaHf4ooAd3vXoOm+aEyP53pjwRXwDEGQxqoODAyYhu0nLMwnzhkLN3sFPI3azlidTv3wo7Xa+NtYbcCWpIBnDIa0VZcQIC5J69Er18GtFjxt2s5QfQgBrm09aSMl33oRwHzLrRY8QzCkrap9l69asFftuDDuigjQ+Xt1UdKm\/ZTX51j3BeuSbD5wuajV9kOugKcciDRVT0KAe7\/LhQCPnTWmVMJ10TBhmihIYV0GhobHQ4AAjYUuBbb8XQFPIRBpqhIfSdHlvqb1x4rAVsDTREFK6+Lvcq\/Eagvc7NWCpxSOpFeLrwCJbx88ORzIcgvkAP5B0\/faVZ90INJSfkKAy7ccsw1DgZQ4txxXulfA00JGCurh73IXlwS4q0kKeArASEMVCAHOa8x1uQN3NVD7r1XA00BHguswPJwLAeInd5weta6IH9Bqj3lY1AdPMCBJLrqMuqHLXXzraoHOv14BTzIhCS47IUBcErrcxSXp7DYm7KSAJxiSpBZdQoC7jw1byx021P78FPCkUpLAcjPqRkKAQIg74YfRxbECnkBQklhkCQHS5Y6\/Dcwdp90nBTyJtCSszIy6wd9mlDtw1wJsuYcCnjBYklRcGXXz\/rou03ZixLok7V3GG\/Feu8QDpWHCJFGTkLJKCJBvscUdqSXYci8FPCHAJKmYjLrBJWGUOw1JgS2KPYDzBtF5UZJEUIzLKl3uLYcHLdwHThkTZVLAYwxLsaLh25LitA0ODtoQIP7u\/pO5hmSUYMu9FfA4UVKyLL3mw7kvmJtuvc1MuXGKefiJl+zMTSUvc\/wDRt3w7TZd7vjbuCICWNR7Bdyx8sPM\/qv5MyzY9a8sN42NjeatR6bbCW\/CvEeleRECfGf1UdvlDtwAjQWPS1LAK9VoVL8f7Tezp95ibr6n3pyOiXfCxDs04HYdHbGx7bhA7S8HjVxtZEYFbQX3HenrMY\/dnQP8cgXXufipTLxDCPDAmDvihypOxwq4CwKc5NlrLTj+9\/5eMeG9ZmBk1MndimUqIUC63OktBOa2E\/FNCngxTcbwvPjgd0x\/3Myc+ZyZUXen2XTIG1Vbo40QIP72lvZBC3ecwZayKeA1giOM2xAa7Fz2mqmrqzPTpt1rZs9ZZFcwCCPvyfKQiXfwZXd\/5zUkPbdkj7cXiOK8p+GrPvhk2s343\/whQMDGJQHupCQFPOMAT1Z9Rt3gknyx56qNbScFan85aSeoBZ9Myxn9G6Nu+J5k+7cjNrbthyZJxwp4RgEuVu0rV3MT79DlDsj417uPJzcB+LzPdRGqYvrO1HlG3WC16XIXXzvJcFN2BTxTCBevrIQAGeUO3EkHW8rPdzFqwYvrPfV\/IfTI8ns0xPC3cUu+OZaeRORHAU89xoUrKKNuFjZftGBj9dIEN3VRwAvrPvVnJQRIlztWu\/VoOhNfN6oFTz3OEyso\/jZd7mmGm4dWAZ+o+1T\/Tybewd9u8ZSPS9JyxEvecVoTDWa14KnGOlc5utwJAfKJK2Bj3SzcAJ7ipIBnAG4ZdUOXu1jtnR7UWUj71IKnl3BCgIy6eWfNabPlUM4lyQLU\/jqGAvjokPlk0Ufm7cUNplaDTW5IL5bh1ExG3dDlLi7Ijm+NyVriUwMe8OrmRem1o6luv2tqzYYLKuCTPAeMuuErQLrccUmwaFkDW+pLlCgMwBlcUsvxsAp4EcAlBLhh36DttNl2OLtwA3nYgLd17DKzZs2yg01cDv5WwPMAZ9QNc28TEtvaOWrdEuDOegoTcOaiwU1hNBXH9z8023hLADnZFHCfWGXUDV3u+NtYrqyDLfVniF1YLgoDvt\/c3WMlP\/fFByzk8n+fOkI5VMDHxCghQLrciW1v6zSeBdckMqANEhbg+OBisRkbixX\/83teeMrBlnnACQEy6obG5MYDI7YhKUrV\/bUHXAF38PS5zlJCgAvW\/2C2jvnZX3uGRNP1MuCLwrAsOBb793OazPnvD47PUdN4etCJujNrwWXUDf424T+stYJdXAahAO5Nm0eYkPlo6usfta4J\/vgzK7Y7gZtMMwm4hADpcqchqWCXlkHLsTAsuDGnjh+x6wsZD\/a2tjbD58Yut0wBLstd86r98uCobUhu6TBGU2kZEFWq3kVxiXLhvDMDuIQA6XL\/eswdUbBLgy0ywo1TwAs\/RJGflVE3dLkT1232rLamymSggEeOceECSAhw7Z4hGylpbvcUq6liGdBWeaOh2o+tCuvI5dnUuigy8Q5d7l96QPOZK3tNwWSggLt8DCvM2x8CxN\/GYivY1clAAa8QQlc\/p8v9Xyu9T1xbBm34b\/NBYzRVLwPaLuqiuKK2jHxl1A1KWN82al2STQp3aA+3Al4GhK5+Qpc7y+\/NW9djXREs9qYDmsKUAT29asFdETxJvhICXPz1VRv6Q6kbNYUuA9oyCvgkILr4E13u+Nurdw1ZuJv2K9yuHm4F3AXBRfKU5a7pWdvQlnNFgFuTOxnwvY5a8CJAhnlaJt7hE1d8baAGck1uZUCXvQIeJskF8pIQ4LKtVy3cCrVbqP3yVcALABnWKX8IcPXuEduA8gtfj92Dzrc7asHDItqXj4y6ebvxnFm3L+eSsNdUWxnQE6yA+8AM41Am3mHUDdEBhTo6GWxWwMNA+loeEgJcsWPEbPDg\/mKvpihlQK\/wayv1a8JrhAY8YtQNE+\/wOlyzO2exolSs3jtnWBTwgED7L5MQIF3u6z0\/G7g+36MpDjLARVQL7qe1wmO63OmVxN\/G10apjZpiIwMFvEKg\/T9n1I184grcuCaa4iUDOtTUgvupLeNYQoB0uYu1Xq1wx\/LhXqeAl0G07yeMumG6tHkb+q2vDdia4isDBdwHb6lDCQHyiSsNyc92aXIpgwbP+jZ4jUS75zhAWut9bKUuSgmyZeIdBLWyJedjfvqNwu0SbuS7uvGYaVz6TdXpH3PWmY2bdhg+nUjKVrNR9Sx3zagbutxFoQhfk1sZ0FG2ZsYfzFcP14WStq1YZQZGRpPCd23mJpQQIP72ai\/0p1DXRgarWo3hs2IAX1b3K7PgyWfMwmdfDpy4ftUqD\/CBAQVcJCAhQPxtGpEIXVNtZIAbSIQKwN96ZLpdD+f1D1tNWWnBdvO6P3nXMeXxx59tNoNX+kS9sd87c1F4yhduPGq73Fd6UH\/qNSQV7NrKYIUH+Py1Z8YtOMBi0ZmfsVTiOn\/i96zCsLSpxYwOX4092FJAJ4BLCBB\/W8DGmmiqrQxW7Lzmoqz77eNm\/vKDZsn2EcP5ksnz3fHfJdFu+tuSrirXyRTsarcPHXAZdfNB86BtTCrUtYXaL+9CgC\/dEaw8tJ0yDbiMuiEEiJXAHSlpJcqxJPqbwHJc7sEsLkrFFjxP7rSfMgu4hAD5xFUsyHJPQJqilQHW2g\/4u\/\/7zhqfIHrJrIvCqBs+lCIEiNUOIjy9xo3cCgLuQR9E3pkEXLrc8bex3AhUU3xksMRb24npowkT4qLkLHiw8hEsyIyLIhPv4G8v8oRIOErBjp8MCgGOvoLoKjOAy6gbQoDLPD8bYSFITfGTweJt11twzgXRFe5n6i24hADxt7HaQQSl19RObgp4Betkrm09aZ9g\/G2sNsLTFG8ZfLz1egvOuSB6o42VSgsuo25y8e2c9QkiIL0mGFjVyK0Q4B8FBJw3duoAlxAg\/jauBcJGaJqSIQNglo+tJIrCuSD6I7SYKsAJAVIh\/O0lnksSRCh6TbRyU8AL+OADQ8OmYfsJOzwJAQE3oSVNyZMBBoa3rz8Ojk6D6HJ5WqIozCrFd7\/Pv9tq07NzdxhNyZVB\/SvLxwHnuBpdwsWXrd40s6NDtfscsMo7TfiakDGT3d1nTFtbm2lqajINDZ9qSrgMPln0kfnPG\/+2iWNG5ATVa3Nzs+nq6jJwkpTtOsAvXOi1lThy5IjRlHwZYKx27txpE8fV6BS4+\/r6kz3omKeTrnhNyZcBo6pY0pxQL2ByzLmguoWNJI2o5y0zwYIn5bWj5VQJlCsBBbxcSenvEikBBTyg2kb6ekxnZ6dNHWcvBsxFL3MtAQU8gIR7Oz4zj919i5ly4xSbbrr1NvPPDYcD5KSXuJaAAh5Awu2bVxmmMaPhNnDxlIX95nvqzeUAeeklbiWggAeUb+ey18yDUx8006bda7Dg7E8nZ8q+gLVO3mUKeACdbXjpd9Y1efiJl8ysWbPMfT\/\/ibn9rqnmXIC89BK3ElDAK5Wv1009e+otBpfEWmzv\/zPq7lTAK5VjjX6vgAcQ9FfzZ1gLjtXGNaGxqRY8gCBrcIkCHlDIX34x17onNDZpdL733vvayAwoS5eXKeAupat5Ry4BBTxyFWgBXEpAAXcpXc07cgko4JGrQAvgUgIKuEvpat6RS0ABj1wFWgCXElDAXUpX845cAgp45CrQAriUgALuUrqad+QSUMAjV4EWwKUEFHCX0tW8I5eAAh65CrQALiWggLuUruYduQQU8MhVoAVwKQEF3KV0Ne\/IJaCAR64CLYBLCSjgLqWreUcuAQU8chVoAVxKQAF3KV3NO3IJKOCRq0AL4FICCrhL6WrekUtAAY9cBVoAlxJQwF1KV\/OOXAIKuKcCu\/LByGikyhgdvmrLEWkhxm7OKhCkNGyZBpyZYT+c+4J56k9Pmfr6R83bixtC1SlLfvScOzfpok0sCcJ0zE\/P\/ON4OSKbb3y03zChEfIgPT3rL6anP1SR1DyzzAPOgrdsQMZssY2nB0NTwvHjx+3UbqxYN9nWfqTdHBoDiYk9mdQzkqmYPcC3tXeOTSLaa\/76m5\/ZZQcnK3vc\/5ZpwCcqp9c894tfmzd390w8XcX\/WNGMeQtZuq\/cjWmZ739odixmquVhY23NJG8K+Jj2xILv7w1vkm8seKWAL3jymXhA5VlzHvikr1yRCcBZ+xPYLlwq4lAOnbCv45ff9NYsL7HhbuCv0zAttQngjY2N9qesM0kqtnW3\/N26SXvPhPeQFbsXq1MUlYk3JTQz6PImuZScNV8LVjXVgLMAKjCyAgOWlP2rr75q14kcl4Znqea++IC57+V3yvJ7mUWWvGg8ltoEcK6ZOfM5ex3XUib+5t94g9z9y5+aj\/ed9J8uekwDVta9lKgHe86VWsuS8jDdM2Vhj0wAXjbcpDumP24OnU\/Okt1S9vx9qgFHkSgP0FnlV+BkKWu7eXCzzHW5cHMNy2EDhh+IXGbX\/wvEPFQkVoKgDFhz\/l9XVzd+wfnvD9r\/l+v\/AzHXS975e+5VbBMZsKc8vJHICxmxMRU0cIfZ2C5WllqcTzXghQSIMgUurCYWjKgFFpa0tKnlusuAGYtNEkBoQMo5rGmhTSw4D5l\/k4eEtd\/ZeIOwYgRgUgbCc5NZTyw0DyllKZQEVv89OaYe8rD5\/yZvA+O5aqxWAeBSltlzFiXaTckE4N3dZ6y1QvHAzaoMdvMs+JUfe835s2cMvyEV8tOJCWO1iyUB1Q8NxwK4+ODydzkPnGyDV\/psOaQM7AccdDyVjOp4vjdloc0iZSnHFZN6xXGfasBp0InFln2+e1COUgCDVzkgY9kAHQvK\/0nF3BUBOT9MKOcF8HLKkP8bHla5f\/6eBWoLbZyn7PkPXKHfpuVcagHHT8VSAzag8xrm1U4Db9yCB9CiuBfldGULyPlAyXnyCrJRF1kbqNBbhTdOoU0Az3\/gCv02LedSCzhQo\/x8ZU5wUQJoEatLvuW8ugXkfB+cPHiTFLO05RSL+1PHQqnYGwXXg\/vi5\/s3Hvxi1\/h\/l8Tj1AIuysRiAwFuBu4FCq7GgmONub7vcnlxcO5HQ5Z740rwwHGOBy2KjYeNB5SHjPJQH8rCcRq31AKOsvBTgQsgSSgX61UruLDQ3Ity8KCJO4ELUc4bwAVwg4ODVg48ZJSHPTLBIKRxSzXgKAxfGetNVICN1zH+eS22\/HvxJpFy1OL+k90DoClPWsGWuqcecKmo7rMpAQU8m3rPTK0V8MyoOpsVVcCzqffM1FoBz4yqs1lRBTybes9MrRXwzKg6mxVVwLOp98zU+v8kGtecVJCs5wAAAABJRU5ErkJggg==","width":117}
%---
