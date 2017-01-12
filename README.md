# Build Promotion Tool

The purpose of this tool is to simplify the tag application process. Three types of tag can be applied: develop, stage, or test.

To apply a develop tag, a search for all previously applied develop tags is conducted on the repository (local and remote). The tag version number is incremented, depending on the most recent develop tag version number, and on the type of version update selected (major, minor, or patch).

To apply a test tag, a develop tag must previously have been applied to the commit. The test tag will be applied to the commit, with a version number matching that of the develop tag.

To apply a stage tag, both a test tag and a develop tag must previously have been applied to the commit. The stage tag will be applied to the commit, with a version number matching those of the test and develop tags.

__Applying a develop tag__
- Run: ruby deploy.rb develop
- If no prior develop tag has been assigned, the user will be asked whether they would like to assign the first develop tag. If they select yes, first tag 'dev-v0.0.1' is applied.
- If previous develop tags have been applied, the latest develop tag is displayed and the user is asked whether they would like to do a _major, minor, or patch_ update.
- The user inputs their choice, and the tag version number is updated.
- The new tag is displayed in the console and a tag is applied.
- The tag is then pushed to the repository (_to be verified_).

__Applying a test tag__
- Run: ruby deploy.rb test
- If no develop tag exists for this commit, an error message is displayed which indicates how the user can check which tags have been assigned to the commit
- If a develop tag exists for this commit, a test tag is applied with the same version number as the develop tag.
- The tag is then pushed to the repository (_to be verified_).

__Applying a stage tag__ (To be completed)
