﻿using System.Collections;
using System.Collections.Generic;

using UnityEngine;
using UnityEngine.UI;

namespace Rise.App.ViewModels {
    public class ProjectDetailMediaPreviewViewModel : MonoBehaviour {
	    public Button view;
	    public RawImage image;
        public AspectRatioFitter aspectRatioFitter;
        public Text title;
	    public GameObject videoIcon;
	    public GameObject threeDIcon;
    }
}