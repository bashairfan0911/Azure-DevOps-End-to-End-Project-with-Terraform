#!/bin/bash

# TODO: CHANGE THESE VALUES BEFORE RUNNING - Replace "piyush" with your name/identifier
RESOURCE_GROUP_NAME=terraform-state-rg
STAGE_SA_ACCOUNT=tfstagebackend2024piyush              # TODO: Change storage account name (must be globally unique, 3-24 chars, lowercase)
DEV_SA_ACCOUNT=tfdevbackend2024piyush                  # TODO: Change storage account name (must be globally unique, 3-24 chars, lowercase)
CONTAINER_NAME=tfstate


# Create resource group
az group create --name $RESOURCE_GROUP_NAME --location canadacentral

# Create storage account for staging environment
az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STAGE_SA_ACCOUNT --sku Standard_LRS --encryption-services blob

# Create storage account for dev environment
az storage account create --resource-group $RESOURCE_GROUP_NAME --name $DEV_SA_ACCOUNT --sku Standard_LRS --encryption-services blob

# Create blob container for staging environment
az storage container create --name $CONTAINER_NAME --account-name $STAGE_SA_ACCOUNT

# Create blob container for dev environment
az storage container create --name $CONTAINER_NAME --account-name $DEV_SA_ACCOUNT