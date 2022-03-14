clear all
close all

%
f = imread('electron_micrograph_of_a_human_chromosome.jpg');
figure, imshow(f);
% pause;
% %
f = 1-im2double(f);
h = fspecial('gaussian',25,15);
g = imfilter(f,h,'replicate');
figure, imshow(g);

%
g = im2bw(g,1.7*graythresh(g));
figure, imshow(g);

[rows cols] = find(g~=0);

contour = bwtraceboundary(g, [rows(1), cols(1)], 'N');

% Subsample the boundary points so we have exactly 128, and put them into a
% complex number format (x + jy)
sampleFactor = length(contour)/128;
dist = 1;
for i=1:128
    c(i) = contour(round(dist),2) + j*contour(round(dist),1);
    dist = dist + sampleFactor;
end

C = fft(c);
% Chop out some of the smaller coefficients (less than umax)
umax = 6;
%umax = 8; 
Capprox = C;
for u=1:128
    if u > umax & u < 128-umax
        Capprox(u) = 0;
    end
end

% Take inverse fft
cApprox = ifft(Capprox);

% Show original boundary and approximated boundary
figure, imshow(imcomplement(bwperim(g)));
hold on, plot(cApprox,'r');

%
% s = bwmorph(g,'skel',Inf);
% figure, imshow(s);
% pause;
% %
% s1 = bwmorph(s,'spur',25);
% figure, imshow(s1);

% f=g;
fSize=size(g);
% g = im2bw(f);

currentMatrix=zeros(3);

testMatrix=[{9,2,3},{8,1,4},{7,6,5}]
testMatrix=[9,2,3; 8,1,4; 7,6,5];

% workingArray=ones(fSize);

newF=zeros(fSize(1)+2,fSize(2)+2);
newF(2:fSize(1)+1,2:fSize(2)+1)=g;

%amount of times algo applied to image
for algoIterations=1:100
    disp(algoIterations)
    if algoIterations==1
        newIterationArray=newF;
        workingArray=ones(fSize);
        %     else
        %         newIterationArray(2:fSize(1)+1,2:fSize(2)+1)=newIterationArray(2:fSize(1)+1,2:fSize(2)+1).*double(workingArray);
        %         workingArray=ones(fSize);
    end


    %making program do certain if conditions so no repetition of code until
    % mulitplication ==0
    for task=1:2


        for i=2:(fSize(1))+1
            for j=2:(fSize(2))+1
                oneNeibourZero=newIterationArray(i-1,j-1)*newIterationArray(i-1,j)*newIterationArray(i-1,j+1)*newIterationArray(i+1,j-1)*newIterationArray(i+1,j)*newIterationArray(i+1,j+1)*newIterationArray(i,j+1)*newIterationArray(i,j-1);
                if newIterationArray(i,j)==1 && oneNeibourZero==0
                    nonZeroTotal=0;
                    if newIterationArray(i-1,j-1)%left top
                        nonZeroTotal=nonZeroTotal+1;
                    end

                    if newIterationArray(i-1,j)%left middle
                        nonZeroTotal=nonZeroTotal+1;
                    end
                    if newIterationArray(i-1,j+1) % left bottom
                        nonZeroTotal=nonZeroTotal+1;
                    end
                    if newIterationArray(i+1,j-1) % right top
                        nonZeroTotal=nonZeroTotal+1;
                    end
                    if newIterationArray(i+1,j) % right middle
                        nonZeroTotal=nonZeroTotal+1;
                    end
                    if newIterationArray(i+1,j+1) % right bottom
                        nonZeroTotal=nonZeroTotal+1;
                    end
                    if newIterationArray(i,j+1) % bottom middle
                        nonZeroTotal=nonZeroTotal+1;
                    end
                    if newIterationArray(i,j-1) % top middle
                        nonZeroTotal=nonZeroTotal+1;
                    end
                    %%
                    %condition a
                    if (nonZeroTotal>=2) && (nonZeroTotal<=6)

                        sequence=[newIterationArray(i,j-1) newIterationArray(i+1,j-1) newIterationArray(i+1,j) newIterationArray(i+1,j+1) newIterationArray(i,j+1) newIterationArray(i-1,j+1) newIterationArray(i-1,j) newIterationArray(i-1,j-1) newIterationArray(i,j-1)];
                        %           p2,                          p3,                             p4,                  p5,                    p6,                     p7,                          p8,                    p9,                         p2

                        TValue=0;
                        for k=1:numel(sequence)-1

                            if(sequence(k)==0 && sequence(k+1)==1)
                                TValue=TValue+1;
                            end

                        end

                        %%
                        %condition b - only done if a and b
                        if TValue==1


                            if task==1
                                %condition c
                                conditionc=newIterationArray(i,j-1) *newIterationArray(i+1,j)*newIterationArray(i,j+1);
                                if conditionc==0

                                    %condition d task 1
                                    conditiond=newIterationArray(i,j+1) *newIterationArray(i-1,j) *newIterationArray(i+1,j);
                                    if conditiond==0
                                        %                                                                 disp("set zero")
                                        workingArray(i-1,j-1)=0;
                                    end

                                end
                            else
                                %condition task 2
                                conditionc=newIterationArray(i,j-1) *newIterationArray(i+1,j)*newIterationArray(i-1,j);
                                if conditionc==0

                                    %condition d task 2
                                    conditiond=newIterationArray(i,j-1) *newIterationArray(i+1,j) *newIterationArray(i-1,j);
                                    if conditiond==0
                                        %                                                                 disp("set zero")
                                        workingArray(i-1,j-1)=0;
                                    end

                                end
                            end


                        end


                    end

                end
            end

        end
        %deleting the values after the tasks
        newIterationArray(2:fSize(1)+1,2:fSize(2)+1)=newIterationArray(2:fSize(1)+1,2:fSize(2)+1).*double(workingArray);
        workingArray=ones(fSize);
    end



end

% newIterationArray(2:fSize(1)+1,2:fSize(2)+1)=newIterationArray(2:fSize(1)+1,2:fSize(2)+1).*double(workingArray);
finalImage=newIterationArray(2:fSize(1)+1,2:fSize(2)+1);
figure,subplot(2,1,1)
imshow(g)
subplot(2,1,2)
imshow(finalImage)