import bb.cascades 1.2
import bb.system 1.2
import bb.data 1.0


TabbedPane
{
    property int number_of_threads;
    property int number_of_downloads;
    property string downloads_directory;
    
    onCreationCompleted: {
        number_of_threads = settings.max_thread;
        number_of_downloads = settings.max_download;
        downloads_directory = settings.location
        Application.aboutToQuit.connect( download_manager.aboutToExit )
    }
    id: root
    function locate_icon( location ){
        console.log( "I've been called.")
        switch ( location ){
            case "picture":
                return "asset:///images/picture.png";
            case "music":
                return "asset:///images/music.png";
            default :
                return "asset:///images/other.png";
        }
    }
    showTabsOnActionBar: true
    Menu.definition: MenuDefinition {
        helpAction: HelpActionItem {
        
        }
        settingsAction: SettingsActionItem {
            onTriggered: {
                var settings = settingsPage.createObject();
                navPane.push( settings )
            }
        }
    }
    attachedObjects: [
        ComponentDefinition {
            id: settingsPage
            source: "asset:///settings.qml"
        }
    ]
    Tab
    {
        id: homepageTab
        title: "Downloads"
        imageSource: "asset:///images/home.png"
        NavigationPane
        {
            id: navPane
            onPopTransitionEnded: {
                number_of_threads = settings.max_thread;
                number_of_downloads = settings.max_download;
                downloads_directory = settings.location
                
                page.destroy()
            }
            
            function status( message )
            {
                busy_wait_activity.stop();
                system_toast.body = message
                system_toast.show();
            }
            
            Page
            {
                titleBar: TitleBar {
                    title: "Crane Download Manager"
                    appearance: TitleBarAppearance.Default
                    kind: TitleBarKind.Default
                    dismissAction: ActionItem {
                        imageSource: "asset:///images/5_content_new.png"
                        onTriggered: {
                            addNewDownload.show()
                        }
                    }
                }
                attachedObjects: [
                    SystemPrompt {
                        id: addNewDownload
                        body: "Enter website address"
                        title: "New Download"
                        onFinished: {
                            switch( value ){
                                case SystemUiResult.ConfirmButtonSelection :
                                    download_manager.addNewUrl( addNewDownload.inputFieldTextEntry(), number_of_threads, 
                                    number_of_downloads, downloads_directory );
                                    busy_wait_activity.start();
                                    break;
                                default :
                                    break;
                            }
                        }
                    },
                    SystemToast {
                        id: system_toast
                    }
                ]
                onCreationCompleted: {
                    download_manager.status.connect( navPane.status );
                    download_manager.error.connect( navPane.status );
                }
                actions: [
                    ActionItem {
                        title: "All"
                        imageSource: "asset:///images/all.png"
                    },
                    ActionItem {
                        title: "Documents"
                        imageSource: "asset:///images/doc.png"
                    },
                    ActionItem {
                        title: "Images"
                        imageSource: "asset:///images/picture.png"
                    },
                    ActionItem {
                        title: "Music"
                        imageSource: "asset:///images/music.png"
                    },
                    ActionItem {
                        title: "Video"
                        imageSource: "asset:///images/video.png"
                    },
                    ActionItem {
                        title: "Programs"
                        imageSource: "asset:///images/exe.png"
                    },
                    ActionItem {
                        title: "Archives"
                        imageSource: "asset:///images/zip.png"
                    },
                    ActionItem {
                        title: "Others"
                        imageSource: "asset:///images/other.png"
                    }
                ]
                Container {
                    topPadding: 20
                    rightPadding: 20
                    leftPadding: 20
                    Container {
                        SegmentedControl
                        {
                            id: segmented_filter
                            onCreationCompleted: {
                                segmented_filter.selectedIndex = 0;
                            }
                            onSelectedIndexChanged: {
                                model_.changeView( selectedIndex );
                            }
                            Option 
                            {
                                id: queueOption
                                text: "Queue"
                            }
                            Option
                            {
                                id: finishedOption
                                text: "Finished"
                            }
                        }
                    }
                    Container {
                        ActivityIndicator {
                            id: busy_wait_activity
                            preferredHeight: 200
                            preferredWidth: 200
                            horizontalAlignment: HorizontalAlignment.Center
                            verticalAlignment: VerticalAlignment.Center
                        }
                    }
                    Container {
                        topPadding: 20
                        ListView {
                            attachedObjects: [
                                CustomListItem {
                                    id: completed_list_item
                                    Container {
                                    
                                    }
                                },
                                StandardListItem {
                                    id: uncompleted_list_item
                                }
                            ]
                            id: list_view
                            
                            dataModel: model_
                            listItemComponents: [
                                ListItemComponent {
                                    type: "item"
                                    CustomListItem {
                                        contextActions: [
                                            ActionSet {
                                                ActionItem {
                                                    title: "View Details"
                                                    imageSource: "asset:///images/info.png"
                                                }
                                                DeleteActionItem {
                                                    title: "Remove from list"
                                                }
                                                ActionItem {
                                                    title: "Delete file";
                                                    imageSource: "asset:///images/delete.png"
                                                }
                                            }
                                        ]
                                        Container {
                                            layout: StackLayout {
                                                orientation: LayoutOrientation.LeftToRight
                                            }
                                            Container {
                                                layoutProperties: StackLayoutProperties {
                                                    spaceQuota: 2
                                                }
                                                ImageView {
                                                    id: download_item_logo
                                                    imageSource: ListItemData.image
                                                }
                                                Label {
                                                    id: download_item_downloaded_size
                                                    text: ListItemData.downloaded_size
                                                }
                                            }
                                            Container {
                                                layoutProperties: StackLayoutProperties {
                                                    spaceQuota: 6
                                                }
                                                Label {
                                                    id: download_item_filename
                                                    text: ListItemData.filename
                                                }
                                                ProgressIndicator {
                                                    fromValue: 1
                                                    toValue: 100
                                                    value: 50
                                                }
                                                Label {
                                                    text: ListItemData.speed
                                                }
                                                rightMargin: 20
                                            }
                                            Container {
                                                layoutProperties: StackLayoutProperties {
                                                    spaceQuota: 2
                                                }
                                                Label {
                                                    id: download_item_status
                                                    text: ListItemData.status
                                                }
                                                Label {
                                                    id: download_item_total_size
                                                    text: ListItemData.total_size
                                                }
                                            }
                                        }
                                    }
                                }
                            ]
                            onTriggered: {
                                list_view.clearSelection()
                                //                            list_view.toggleSelection( indexPath )
                                select( indexPath )
                            }
                        }
                    }
                }
            }
        }
    }
}