﻿using System.Collections;
using System.Collections.Generic;

using UnityEngine;

namespace Rise.App.Models {
	[System.Serializable]
	public class Media : ISerializationCallbackReceiver {
		[SerializeField]
		private string id;
		public string Id {
			get {
				return id;
			}
			set {
				id = value;
			}
        }

        [SerializeField]
        private string name;
        public string Name {
            get {
                return name;
            }
            set {
                name = value;
            }
        }

        [SerializeField]
		private string projectID;
		public string ProjectID {
			get {
				return projectID;
			}
			set {
				projectID = value;
			}
		}
			
		public enum MediaType {
			SCENE,
			IMAGE,
			VIDEO,
			DOCUMENT,
			TEXT,
            THUMBNAIL
		}

		[SerializeField]
		private string type;
		private MediaType _type;
		public MediaType Type {
			get {
				return _type;
			}
			set {
				_type = value;
			}
		}

		[SerializeField]
		private string key;
		public string Key {
			get {
				return key;
			}
			set {
				key = value;
			}
		}

		[SerializeField]
		private string value;
		public string Value {
			get {
				return value;
			}
			set {
				this.value = value;
			}
		}

        [SerializeField]
        private string thumbnailID;
        public string ThumbnailID {
            get {
                return thumbnailID;
            }
            set {
                thumbnailID = value;
            }
        }

		[SerializeField]
		private string publicURL;
		public string PublicURL {
			get {
				return publicURL;
			}
			set {
                publicURL = value;
			}
		}

		public void OnBeforeSerialize() {}

		public void OnAfterDeserialize() {
            if(string.IsNullOrEmpty(type)) {
                return;
            }

			_type = (MediaType)System.Enum.Parse(typeof(MediaType), type);
		}
	}
}