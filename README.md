# Build Promotion Tool

The purpose of this tool is to simplify the tag application process. Three types of tag can be applied: develop, stage, or test.

To apply a develop tag, a search for all previously applied develop tags is conducted on the repository (local and remote). The tag version number is incremented, depending on the most recent develop tag version number, and on the type of version update selected (major, minor, or patch).
Two develop tags cannot be applied to the same repository

To apply a test tag, a develop tag must previously have been applied to the commit. The test tag will be applied to the commit, with a version number matching that of the develop tag.

To apply a stage tag, both a test tag and a develop tag must previously have been applied to the commit. The stage tag will be applied to the commit, with a version number matching those of the test and develop tags.

__Applying a develop tag__
- Run: ruby deploy.rb develop
- If no prior develop tag has been assigned, the user will be asked whether they would like to assign the first develop tag. If they select yes, first tag 'dev-v0.0.1' is applied.
- If previous develop tags have been applied, the latest develop tag is displayed and the user is asked whether they would like to do a _major, minor, or patch_ update. See: [Semantic Versioning](http://semver.org).
- The user inputs their choice, the user is shown the new tag and is asked to confirm their choice and apply the tag.
- When the user selects yes ('y') to updating the tag, the tag version number is updated.
- The tag is then added to the repository and pushed to the remote.

__Applying a test tag__
- Run: ruby deploy.rb test
- If no develop tag exists for this commit, an error message is displayed.
- If a develop tag exists for this commit, the user is shown the tag and asked if they would like to apply it.
- If the user selects yes ('y') then the tag is applied
- The tag is then added to the repository and pushed to the remote.

__Applying a stage tag__
- Run: ruby deploy.rb stage
- If no test tag exists for this commit, an error message is displayed.
- If a test tag exists for this commit, the user is shown the tag and asked if they would like to apply it.
- If the user selects yes ('y') then the tag is applied
- The tag is then added to the repository and pushed to the remote.

__Tests Completed for Synchronising remote tags with local repo__  
- A new tag is applied and pushed to the remote for develop, test and stage when the most recent tag has been applied locally

Given the most recent tag has been applied locally
When the user would like to apply a new <tag-type> tag
Then the tag number is updated
And the tag pushed to the repo
  |tag-type |
  |develop  |
  |test     |
  |stage    |


Given the most recent develop tag is on the remote
When the user would like to like to apply a new <tag-type> tag
Then the tag number is updated using the remote tag version number  
And the tag is pushed to the repo
  |tag-type |
  |develop  |
  |test     |

Given the most recent test tag is on the remote
When the user would like to like to apply a new <tag-type> tag
Then the tag number is updated using the remote tag version number  
And the tag is pushed to the repo
  |tag-type |
  |develop  |
  |test     |





- Delete most recent tag locally, stay on same commit.
1. Update develop tag
2. Update test tag
3. Update stage tag

1. Update test tag (without updating develop)

1. Update stage tag (without updating test)

- Delete most recent tag locally (contained on remote). Add a new develop tag. Is the next dev/test/stage number updated?




- Delete most recent tags locally, stay on same commit.
1. Update develop tag
2. Update test tag
3. Update stage tag

1. Update test tag (without updating develop)

1. Update stage tag (without updating test)

- Delete most recent tags locally (contained on remote). Add a new develop tag. Is the next dev/test/stage number updated? Is the new number pushed to remote.
