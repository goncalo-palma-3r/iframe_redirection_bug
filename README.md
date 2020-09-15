# iframe_redirection_bug

This repo serves to show the iFrame redirection bug.

Case in point:

When we have an IFrameElement in Flutter Web, if we click on any url inside
the IFrame and are redirected to a new website, the `src` of the `IFrameElement` 
does not change, and we cannot retrieve the current information from the URL