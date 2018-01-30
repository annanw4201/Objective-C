# Notes during doing the projects (needs to update as many notes as possible by reviewing from the begining)

- view controller life cycles: view will load -> view did load -> view will appear -> view will disappear -> view did disappear
- remember always to check if the outlets have been wired up
- table view: need to set up resuable identifier for cells
- table view: properties should be strong, otherwise the properties value will be nil as soon as some one else doesn't retain it
- table view: the cell type should be set properly(like if the cell has subtitle or not), otherwise when seeting some properties of cell, it will not shown when launching the app
- image view: set the frame as the image's original width and height, otherwise, the image will fit into a screen and will be distorted
- image view: set clip to bounds property to let the view can display image on the whole screen when rotating
- scroll view: need to set the image view to be the zooming view
- scroll view: to scale the image, find the minimum scale factor such that widthScale = scrollview.width / image.width and heightScale = scrollview.height / image.height. Then the image will scale using these two scale factor but have to match (scroll.minScale, scroll.maxScale)
- scroll view: need to set minimum and maximum allowed scale, or the scale won't work
- scroll view: set content size as the same size as the image that's going to be scrolled, so that it will cover all the area of image and don't have extra spacing
- scroll view: set the content off set to (0,0) will align the image to the top left corner
