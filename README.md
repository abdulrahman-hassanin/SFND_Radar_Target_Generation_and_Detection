# Implementation steps for the 2D CFAR process.

1. Determine the number of Training cells for each dimension Tr and Td. Similarly, pick the number of guard cells Gr and Gd.

2. Slide the Cell Under Test (CUT) across the complete cell matrix.

3. Select the grid that includes the training, guard and test cells. Grid Size = (2Tr+2Gr+1)(2Td+2Gd+1).

4. The total number of cells in the guard region and cell under test. (2Gr+1)(2Gd+1).

5. This gives the Training Cells : (2Tr+2Gr+1)(2Td+2Gd+1) - (2Gr+1)(2Gd+1)

6. Measure and average the noise across all the training cells. This gives the threshold

7. Add the offset (if in signal strength in dB) to the threshold to keep the false alarm to the minimum.

8. Determine the signal level at the Cell Under Test.

9. If the CUT signal level is greater than the Threshold, assign a value of 1, else equate it to zero.

10. Since the cell under test are not located at the edges, due to the training cells occupying the edges, 
    we suppress the edges to zero. Any cell value that is neither 1 nor a 0, assign it a zero.
    
```matlab script
%Select the number of Training Cells in both the dimensions.
Tr = 10;    % range Dimension
Td = 8;     % Doppler Dimension

%Select the number of Guard Cells in both dimensions around the Cell under 
%test (CUT) for accurate estimation
Gr = 4;
Gd = 4;

% offset the threshold by SNR value in dB
offset = 0.2;

gridSize = (2*Tr + 2*Gr +1)*(2*Td + 2*Gd +1);
trainCellSize = gridSize - (2*Gr + 1)*(2*Gd+1);




   % Use RDM[x,y] as the matrix from the output of 2D FFT for implementing
   % CFAR
RDM = RDM/max(max(RDM));

for i = Tr+Gr+1: (Nr/2)-(Tr+Gr)        % To avoid edges
    for j = Td+Gd+1 : Nd-Td-Gd
        noise_level = zeros(1,1);
        % sum noise around CUT
        for p = i-(Tr+Gr): i+Tr+Gr
            for q = j-(Td+Gd): j+Td+Gd
                if(abs(i-p) > Gr || abs(j-q))
                    noise_level = noise_level + db2pow(RDM(p,q));
                end
            end
        end
        
        % Calculate threshold
        noise_level_avr = noise_level / trainCellSize;
        threshold = pow2db(noise_level_avr) + offset;
        
        CUT = RDM(i,j);
        if (CUT < threshold)
            RDM(i,j)=0;
        else
            RDM(i,j)=1;
        end    
    end    
end
```
# Selection of Training, Guard cells and offset.
- Number of Training cells in range dimension (Tr) = 10
- Number of Training cells in doppler dimension (Td) = 8
- Number of Guard cells in range dimension (Gr) = 4
- Number of Guard cells in doppler dimension (Gd) = 4
- Offset = 0.2

# teps taken to suppress the non-thresholded cells at the edges.
Any cell value that is neither 1 nor a 0, assign it a zero.
```matlab script
RDM(RDM~=0 & RDM~=1) = 0;
```

# output
![Range First FFT](./media/Range from First FFT)

*Range*

![Range](./media/Range and Speed from FFT2)

*Range from FFT2*

![CACFAR Surface Plot](./media/CA-CFAR Filtered RDM)

*CACFAR Surface Plot*
