#!/bin/bash

# WordPress site URL
SITE_URL="storiestoamaze.com"

# SSH details (if needed) in the format [user@]host[:port]
# Uncomment and fill in the next line if connecting via SSH
# SSH_DETAILS="user@host"

# Path to the images directory
IMAGE_DIR="/images"

# Loop through generated post files
for post_file in post_*.txt
do
  # Create and publish the post
  # Include --url for site URL and optionally --ssh for SSH details
  if [ -z "${SSH_DETAILS}" ]; then
    POST_ID=$(wp post create $post_file --format=ids --url=$SITE_URL)
  else
    POST_ID=$(wp post create $post_file --format=ids --url=$SITE_URL --ssh=$SSH_DETAILS)
  fi

  # Get the image file corresponding to the post
  IMAGE_FILE="$IMAGE_DIR/image_$(basename $post_file .txt).jpg"

  # Upload the image and get its ID
  # Include --url for site URL and optionally --ssh for SSH details
  if [ -z "${SSH_DETAILS}" ]; then
    FEATURED_IMAGE_ID=$(wp media import $IMAGE_FILE --porcelain --url=$SITE_URL)
  else
    FEATURED_IMAGE_ID=$(wp media import $IMAGE_FILE --porcelain --url=$SITE_URL --ssh=$SSH_DETAILS)
  fi

  # Set the featured image
  if [ -z "${SSH_DETAILS}" ]; then
    wp post meta add $POST_ID _thumbnail_id $FEATURED_IMAGE_ID --url=$SITE_URL
  else
    wp post meta add $POST_ID _thumbnail_id $FEATURED_IMAGE_ID --url=$SITE_URL --ssh=$SSH_DETAILS
  fi
  
  echo "Post published successfully with ID: $POST_ID and Featured Image ID: $FEATURED_IMAGE_ID"
done