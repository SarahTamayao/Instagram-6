# Project 4 - *Instagram*

**Instagram** is a photo sharing app using Parse as its backend.

Time spent: **28** hours spent in total

## User Stories

The following **required** functionality is completed:

- [X] User can sign up to create a new account using Parse authentication
- [X] User can log in and log out of his or her account
- [X] The current signed in user is persisted across app restarts
- [X] User can take a photo, add a caption, and post it to "Instagram"
- [X] User can view the last 20 posts submitted to "Instagram"
- [X] User can pull to refresh the last 20 posts submitted to "Instagram"
- [X] User can tap a post to view post details, including timestamp and caption.

The following **optional** features are implemented:

- [X] Run your app on your phone and use the camera to take the photo
- [X] User can load more posts once he or she reaches the bottom of the feed using infinite scrolling.
- [X] Show the username and creation time for each post
- [X] User can use a Tab Bar to switch between a Home Feed tab (all posts) and a Profile tab (only posts published by the current user)
- User Profiles:
  - [ ] Allow the logged in user to add a profile photo
  - [ ] Display the profile photo with each post
  - [ ] Tapping on a post's username or profile photo goes to that user's profile page
- [X] After the user submits a new post, show a progress HUD while the post is being uploaded to Parse
- [ ] User can comment on a post and see all comments for each post in the post details screen.
- [X] User can like a post and see number of likes for each post in the post details screen. **I implemented likes on the home feed, but users can still see the number of likes and like/unlike a post**
- [ ] Style the login page to look like the real Instagram login page.
- [X] Style the feed to look like the real Instagram feed. ***maybe not exactly like the real thing, but working towards it**
- [ ] Implement a custom camera view.

The following **additional** features are implemented:

- [X] User can double tap on an image to like it, just like on the real Instagram
- [X] Feed automatically reloads every 10 minutes so that posts don't get too out of date
- [X] Usernames are shown with table view section headers on home feed

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. I want to learn more about autolayout and styling on collection views -- there seem to be a lot of cool things you can do with them in terms of styling, but I'm not quite sure I know how yet.
2. I want to discuss further about using sections and section headers in table views. I think they are very useful, but it's a newer concept, and I think I could benefit from working with my peers on it for more practice and find situations in which they would be helpful.

## Video Walkthrough

Here's a walkthrough of implemented user stories:

Login/Logout:

![](https://i.imgur.com/J6dFnbc.gif)


Main functionalities:

<img src='insta_main_funcs' title='Main functionalities' width='' alt='Main functionalities' />


User Profile/Persistence:

<img src='insta_profile_persistence' title='Profile, Persistence' width='' alt='Profile, Persistence' />


Screen Rotation:

![](https://i.imgur.com/7MBjwqm.gif)


GIF created with [Kap](https://getkap.co/).

## Credits

List an 3rd party libraries, icons, graphics, or other assets you used in your app.

- [AFNetworking](https://github.com/AFNetworking/AFNetworking) - networking task library
- [DateTools](https://github.com/MatthewYork/DateTools) - date formatting library
- [MBProgressHUD](https://github.com/jdg/MBProgressHUD) - loading indicator library


## Notes

One challenging concept to grasp this week was table view sections. We had previously only worked with rwos, so having sections along with rows within sections was a new concept that came with a lot more intertwined functions. Understanding what the functions did and how they relate to the structure of the table view was a fun challenge!

## License

    Copyright [2021] [Sabrina Meng]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
