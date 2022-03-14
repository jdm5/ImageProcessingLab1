clear all
close all

%
f = imread('electron_micrograph_of_a_human_chromosome.jpg');
figure, imshow(f);
f = 1-im2double(f);
h = fspecial('gaussian',25,15);
g = imfilter(f,h,'replicate');
figure, imshow(g);
pause;
%
g = im2bw(g,1.7*graythresh(g));
% pause;
% %
% f = 1-im2double(f);
% h = fspecial('gaussian',25,15);
% g = imfilter(f,h,'replicate');
% figure, imshow(g);
% pause;
% %
% g = im2bw(g,1.7*graythresh(g));
% figure, imshow(g);
% pause;
% %
% s = bwmorph(g,'skel',Inf);
% figure, imshow(s);
% pause;
% %
% s1 = bwmorph(s,'spur',25);
% figure, imshow(s1);


fSize=size(g);

currentMatrix=zeros(3);

testMatrix=[{9,2,3},{8,1,4},{7,6,5}]
testMatrix=[9,2,3; 8,1,4; 7,6,5];

% workingArray=ones(fSize);

newF=zeros(fSize(1)+2,fSize(2)+2);
newF(2:fSize(1)+1,2:fSize(2)+1)=g;


for algoIterations=1:200
    disp(algoIterations)
    if algoIterations==1
        newIterationArray=newF;
        workingArray=ones(fSize);
    else
        newIterationArray(2:fSize(1)+1,2:fSize(2)+1)=newIterationArray(2:fSize(1)+1,2:fSize(2)+1).*double(workingArray);
        workingArray=ones(fSize);
    end


    for task=1:2


        for j=2:(fSize(1))+1
            for i=2:(fSize(2))+1


                nonZeroTotal=0;
                if ~newIterationArray(i-1,j-1)%left top
                    nonZeroTotal=nonZeroTotal+1;
                end

                if ~newIterationArray(i-1,j)%left middle
                    nonZeroTotal=nonZeroTotal+1;
                end
                if ~newIterationArray(i-1,j+1) % left bottom
                    nonZeroTotal=nonZeroTotal+1;
                end
                if ~newIterationArray(i+1,j-1) % right top
                    nonZeroTotal=nonZeroTotal+1;
                end
                if ~newIterationArray(i+1,j) % right middle
                    nonZeroTotal=nonZeroTotal+1;
                end
                if ~newIterationArray(i+1,j+1) % right bottom
                    nonZeroTotal=nonZeroTotal+1;
                end
                if ~newIterationArray(i,j+1) % bottom middle
                    nonZeroTotal=nonZeroTotal+1;
                end
                if ~newIterationArray(i,j-1) % top middle
                    nonZeroTotal=nonZeroTotal+1;
                end
                %%
                %condition a
                if (nonZeroTotal>=2) && (nonZeroTotal<=6)

                    sequence=[newIterationArray(i,j-1) newIterationArray(i+1,j-1) newIterationArray(i,j) newIterationArray(i+1,j+1) newIterationArray(i,j+1) newIterationArray(i-1,j+1) newIterationArray(i-1,j) newIterationArray(i-1,j-1) newIterationArray(i,j-1)];
                    %           p2,             p3,             p4,      p5,            p6,         p7,             p8,         p9,             p2

                    TValue=0;
                    for i=1:numel(sequence)-1

                        if(sequence(i)==0 && sequence(i+1)==1) | (sequence(9)==0 && sequence(1)==1)
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

                                %condition d
                                conditiond=newIterationArray(i,j+1) *newIterationArray(i-1,j) *newIterationArray(i+1,j);
                                if conditiond==0
                                                                disp("set zero")
                                    workingArray(i,j)=0;
                                end

                            end
                        else
                            conditionc=newIterationArray(i,j-1) *newIterationArray(i+1,j)*newIterationArray(i-1,j);
                            if conditionc==0

                                %condition d
                                conditiond=newIterationArray(i,j-1) *newIterationArray(i+1,j) *newIterationArray(i-1,j);
                                if conditiond==0
                                                                disp("set zero")
                                    workingArray(i,j)=0;
                                end

                            end
                        end


                    end


                end

            end
        end
    end



end

newIterationArray(2:fSize(1)+1,2:fSize(2)+1)=newIterationArray(2:fSize(1)+1,2:fSize(2)+1).*double(workingArray);
subplot(2,1,1)
imshow(f)
subplot(2,1,2)
imshow(newIterationArray)