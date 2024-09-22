# functions
## returnMoviePreview
This function aims to return a movie's details, including


- id 
    - imdb_id  ✅
    - movie_id ✅
- basic info
    - title ✅
    - original_title ✅
    - overview ✅
    - release_date ✅
    - runtime ✅
    - status (released or not) ✅
- images
    - backdrop\_path ✅
    - poster\_path ✅
- crew
    - director **
    - screenwriter **
    - rest of crew
- awards
- production company ✅
- country ✅
- genre ✅ 
- spoken language  ✅
- rating (imdb, metaccritic, tomato)
and which lists it belongs in

https://api.themoviedb.org/3/movie/[id] returns everything except 
- crew (https://api.themoviedb.org/3/movie/[id]/credits)
- awards (*later feature!*)
- rating  (later feature?)


