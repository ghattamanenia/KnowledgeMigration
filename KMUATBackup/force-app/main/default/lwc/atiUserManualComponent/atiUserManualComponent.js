import { LightningElement, track, wire } from 'lwc';
import getKnowledgeBaseTree from '@salesforce/apex/UserManualController.getUserManualTree';

export default class AtiUserManualComponent extends LightningElement {
    @track treeData = [];
    expandedItemId = null; // Track the currently expanded item

    @wire(getKnowledgeBaseTree)
    wiredKnowledgeBase({ error, data }) {
        if (data) {
            this.treeData = this.buildTree(data);
        } else if (error) {
            console.error('Error fetching Knowledge Base:', error);
        }
    }

    buildTree(data) {
        const map = {};
        const tree = [];

        // Build a map of all items by Id
        data.forEach(item => {
            map[item.Id] = {
                id: item.Id,
                title: item.Title__c,
                content: item.Content__c,
                isContentVisible: false, // Initially, the content is hidden
                items: []
            };
        });

        // Organize items into a hierarchy
        data.forEach(item => {
            if (item.Parent_Knowledge_Base__c) {
                map[item.Parent_Knowledge_Base__c].items.push(map[item.Id]);
            } else {
                tree.push(map[item.Id]);
            }
        });

        return tree;
    }

    handleClick(event) {
        const selectedId = event.target.dataset.id;

        // If the same item is clicked, toggle visibility
        if (this.expandedItemId === selectedId) {
            this.toggleContentVisibility(this.treeData, selectedId, false);
            this.expandedItemId = null;
        } else {
            // Collapse the previously expanded item, if any
            if (this.expandedItemId) {
                this.toggleContentVisibility(this.treeData, this.expandedItemId, false);
            }
            // Expand the newly selected item
            this.toggleContentVisibility(this.treeData, selectedId, true);
            this.expandedItemId = selectedId;
        }
    }

    toggleContentVisibility(tree, id, isVisible) {
        for (let item of tree) {
            if (item.id === id) {
                item.isContentVisible = isVisible;
            } else if (item.items && item.items.length > 0) {
                // Recursively check for the item in child nodes
                this.toggleContentVisibility(item.items, id, isVisible);
            }
        }
        // Trigger reactivity by reassigning treeData
        this.treeData = [...this.treeData];
    }
}