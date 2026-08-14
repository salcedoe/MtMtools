# Unit 2 Updates for 2026

New Script Order

- Measuring by Triangles is now a  standalone Live script referred to as needed by the X-Labeled Live scripts

## Exam Updates

- Change all segmentation questions to be far more open ended (Segment to get the following mask)
  - Students can use any approach to mask
  
- For these types of questions, the only thing tested is the mask

- Add three tests for each segmentation (Bare minimum JC>.75, Good, JC>.85, Best, JC>.9)

  

## New Homework Questions

- For X5 - Seg by App: Add a homework assignment to create a function using MATLAB grader that will segment some image (So they get experience creating functions for  MATLAB grader). 

- Grader 6 Homework updates
  - The M&M conversion to millimeter question was not clear - I said here is the size of an M&M in Pixels, but I meant in millimeters,
  - I also told them to convert to mm, which could be misconstrued as M&Ms
  - The size of the image was not clear (I had them input the size of an RGB image, but I only want the width and height of the image)
- Cam Sim (on Canvas) One Question has confusing instructions (asks for blurry background, but the example image does not have a blurry background).
- Update Microscope Quiz - Lens Question - Reference the Lens Live script
- Make sure to provide answer keys for all the homework so student can review the homework on their own time 





## MATLAB Script Updates

### General Notes

Will be reducing the amount of content covered in class with these updates, so I will need more content/more homework assignments  for the students to work on in class. 

Ideas for new content:

- Implement: Cellpose - SAM: https://huggingface.co/spaces/mouseland/cellpose

- Get to Segmentation by distance even earlier — maybe even with the M&Ms
- Spend time Reviewing the homework in class - provide answer keys, but go over the homework that seems to have troubles
- Review how to answer questions using MATLAB grader
- Create more in class exercises - Jaccard Indices

  - Be sure to update L\*a\*b\* examples throughout, especially for H&E

### Script Changes Overview

- Demote the Lens Livescript to an unnumbered script
- Measuring with Triangles (and bwdist) - 
- C

- X5:  Color Segmentation by App
    - drop the whole
- X6:  Color Segmentation by Programming
    - I don’t think they really need to know multithresh (so, likely will be skipping this discussion)

- X8 Brightfield

  - Add back cell colony? With SAM?
  - Lung700 dataset
    - a little confusing
    - Maybe start with a Just one Image for image processing
    - Then get into multi-image processing
    - Use K-means segmentation? Or find their segmentation tool?
    - then create the table from the names
    - Increase description about the Lung700 dataset
- X9 Needs a Careful Revamp

  - Revamp the first example — that’s now a homework
  - Add exercise to process a folder of 4X Olimages
  - Move the Scale bar to a separate exercise 
  - X9 is also very long, so maybe just two examples?
- X10 - To be discontinued
    - Creating a separate script for measuring with triangles
    - Rolling M&M Segmentation with the Revamped X6
- Fly brain Visualization - add livescript to visualize the  full Fly Brain using volshow (to follow the EM Lecture) - a preview of volume rendering for the next unit

  



https://osxdaily.com/2025/10/02/9-macos-tahoe-tips-youll-actually-use/

Segmentation



Segmentation