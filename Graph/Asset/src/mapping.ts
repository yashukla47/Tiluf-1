import { NewGravatar, UpdatedGravatar } from '../generated/Gravity/Gravity'
import { Gravatar } from '../generated/schema'

export function handleCreateAsset(event: createAsset): void {
  let asset = new Asset(event.params.id.toHex()+"Asset")
  asset.identity = event.params.id
  asset.name = event.params.name
  asset.category = event.params.category
  asset.owner = event.params.owner
  asset.forSale = event.params.forSale
  asset.price = event.params.price
  asset.description = event.params.descrip
  asset.save()
}

export function handleUpdateAsset(event: updateAsset): void {
  let id = event.params.id.toHex()+"Asset"
  let asset = Asset.load(id)
  if (asset == null) {
    asset = new Asset(id)
  }
  asset.identity = event.params.id
  asset.name = event.params.name
  asset.description = event.params.descrip
  asset.price = event.params.price
  asset.save()
}

export function handleTransferAsset(event: transferAsset): void {
  let id = event.params.id.toHex()+"Asset"
  let asset = Asset.load(id)
  if (asset == null) {
    asset = new Asset(id)
  }
  asset.identity = event.params.id
  asset.owner = event.params.owner
}

export function handleSell(event: sell): void {
  let id = event.params.id.toHex()+"Asset"
  let asset = Asset.load(id)
  if (asset == null) {
    asset = new Asset(id)
  }
  asset.identity = event.params.id
  asset.forSale = event.params.forSale
}




